Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaBQKH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 05:07:58 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60826 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaBQKHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:07:55 -0500
MIME-Version: 1.0
In-Reply-To: <87r476xj6n.fsf@sejong.aot.lge.com>
References: <CABPqkBSzttXoe3f_jC=Fv+ieN7_TNxLMDs4CH1C0TLYRq+Oz7g@mail.gmail.com>
	<52FC12E3.9060300@lge.com>
	<CABPqkBRMZV_5XH0C5EDD547XcFy=qbREwx8ZA+KWVQxK0nrnug@mail.gmail.com>
	<87r476xj6n.fsf@sejong.aot.lge.com>
Date: Mon, 17 Feb 2014 11:07:54 +0100
Message-ID: <CABPqkBTzhTE9g5KhfZF74kOdkEJqpaYSVGjFJWR-+9_qMoJnTg@mail.gmail.com>
Subject: Re: [BUG] perf report/annotate: consuming too many file descriptors
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Fri, Feb 14, 2014 at 8:11 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>
> Hi Stephane,
>
> On Thu, 13 Feb 2014 17:26:30 +0100, Stephane Eranian wrote:
> > Hi,
> >
> > Your patch does solve the file consumption problem on my test case.
> > We still open and do the ELF read 5 times.
> >>> The first problem is why is dso__read_binary_type_filename()
> >>> blindly returning success on many types. For my files, I got matches
> >>> on DEBUGLINK, SYSTEM_DSO_PATH, GUEST_KMODULE,
> >>> SYSTEM_PATH_KMODULE.
>
> Hmm.. the dso__read_binary_type_filename() will be called for either of
> user binaries or kernel modules.  But for each binary, it's pointless to
> check both types of symtab since it can only have one type.
>
> So I think we should try SYMTEM_PATH_DSO, DEBUGLINK, BUILD_ID_CACHE and
> a couple of DEBUGINFOs for user binaries, and only try *_KMODULE for
> kernel modules.  This way, we can reduce the unnecessary open and ELF
> reading/parsing time.
>
> Could you please test following patch also?
>
Patch worked on my test case.
Thanks.


>
>
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index a9d758a3b371..303b8dc59dd8 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1251,6 +1251,46 @@ out_failure:
>         return -1;
>  }
>
> +static bool dso__is_compatible_symtab_type(struct dso *dso, bool kmod,
> +                                          enum dso_binary_type type)
> +{
> +       switch (type) {
> +       case DSO_BINARY_TYPE__JAVA_JIT:
> +       case DSO_BINARY_TYPE__DEBUGLINK:
> +       case DSO_BINARY_TYPE__SYSTEM_PATH_DSO:
> +       case DSO_BINARY_TYPE__FEDORA_DEBUGINFO:
> +       case DSO_BINARY_TYPE__UBUNTU_DEBUGINFO:
> +       case DSO_BINARY_TYPE__BUILDID_DEBUGINFO:
> +       case DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO:
> +               return !kmod && dso->kernel == DSO_TYPE_USER;
> +
> +       case DSO_BINARY_TYPE__KALLSYMS:
> +       case DSO_BINARY_TYPE__VMLINUX:
> +       case DSO_BINARY_TYPE__KCORE:
> +               return dso->kernel == DSO_TYPE_KERNEL;
> +
> +       case DSO_BINARY_TYPE__GUEST_KALLSYMS:
> +       case DSO_BINARY_TYPE__GUEST_VMLINUX:
> +       case DSO_BINARY_TYPE__GUEST_KCORE:
> +               return dso->kernel == DSO_TYPE_GUEST_KERNEL;
> +
> +       case DSO_BINARY_TYPE__GUEST_KMODULE:
> +       case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE:
> +               /*
> +                * kernel modules know their symtab type - it's set when
> +                * creating a module dso in machine__new_module().
> +                */
> +               return kmod && dso->symtab_type == type;
> +
> +       case DSO_BINARY_TYPE__BUILD_ID_CACHE:
> +               return true;
> +
> +       case DSO_BINARY_TYPE__NOT_FOUND:
> +       default:
> +               return false;
> +       }
> +}
> +
>  int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
>  {
>         char *name;
> @@ -1261,6 +1301,7 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
>         int ss_pos = 0;
>         struct symsrc ss_[2];
>         struct symsrc *syms_ss = NULL, *runtime_ss = NULL;
> +       bool kmod;
>
>         dso__set_loaded(dso, map->type);
>
> @@ -1301,7 +1342,11 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
>         if (!name)
>                 return -1;
>
> -       /* Iterate over candidate debug images.
> +       kmod = dso->symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE ||
> +               dso->symtab_type == DSO_BINARY_TYPE__GUEST_KMODULE;
> +
> +       /*
> +        * Iterate over candidate debug images.
>          * Keep track of "interesting" ones (those which have a symtab, dynsym,
>          * and/or opd section) for processing.
>          */
> @@ -1311,6 +1356,9 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
>
>                 enum dso_binary_type symtab_type = binary_type_symtab[i];
>
> +               if (!dso__is_compatible_symtab_type(dso, kmod, symtab_type))
> +                       continue;
> +
>                 if (dso__read_binary_type_filename(dso, symtab_type,
>                                                    root_dir, name, PATH_MAX))
>                         continue;
> @@ -1351,15 +1399,10 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
>         if (!runtime_ss && syms_ss)
>                 runtime_ss = syms_ss;
>
> -       if (syms_ss) {
> -               int km;
> -
> -               km = dso->symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE ||
> -                    dso->symtab_type == DSO_BINARY_TYPE__GUEST_KMODULE;
> -               ret = dso__load_sym(dso, map, syms_ss, runtime_ss, filter, km);
> -       } else {
> +       if (syms_ss)
> +               ret = dso__load_sym(dso, map, syms_ss, runtime_ss, filter, kmod);
> +       else
>                 ret = -1;
> -       }
>
>         if (ret > 0) {
>                 int nr_plt;
