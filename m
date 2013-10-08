Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab3JHHlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:41:37 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50015 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3JHHlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:41:36 -0400
X-AuditID: 9c930197-b7bd9ae000006889-ce-5253b72ee0b9
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V4 8/9] perf buildid-cache: add ability to add kcore to the cache
References: <1381128618-22721-1-git-send-email-adrian.hunter@intel.com>
	<1381128618-22721-9-git-send-email-adrian.hunter@intel.com>
Date: Tue, 08 Oct 2013 16:41:34 +0900
In-Reply-To: <1381128618-22721-9-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Mon, 7 Oct 2013 09:50:17 +0300")
Message-ID: <87k3hoky4x.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Oct 2013 09:50:17 +0300, Adrian Hunter wrote:
> kcore can be used to view the running kernel object code.
> However, kcore changes as modules are loaded and unloaded,
> and when the kernel decides to modify its own code.
> Consequently it is useful to create a copy of kcore at a
> particular time.  Unlike vmlinux, kcore is not unique
> for a given build-id.  And in addition, the kallsyms
> and modules files are also needed.  The tool therefore
> creates a directory:
>
> 	~/.debug/[kernel.kcore]/<build-id>/<YYYYmmddHHMMSShh>
>
> which contains: kcore, kallsyms and modules.

Hmm..  I think the problem is that the kallsyms and kcore also have
module information and the build-id of kernel can identify the core
kernel part only.  So why not splitting modules from kcore and kallsyms?

As the modules have their own build-id, we can extract module info from
kcore and kallsyms and put them under ~/.debug/[module]/<build-id>.
While at it, we can even synthesize symbol table and inject it into the
module kcore and get rid of the module kallsyms file.

This way, we can identify all binaries using build-id only, no?

>
> Note that the copied kcore contains only code sections.
> See the kcore_copy() function for how that is determined.
>
> The tool will not make additional copies of kcore if there
> is already one with the same modules at the same addresses.
>
> Currently, perf tools will not look for kcore in the cache.
> That is addressed in another patch.
>
[SNIP]

> +static int build_id_cache__kcore_buildid(const char *proc_dir, char *sbuildid)
> +{
> +	char root_dir[PATH_MAX];
> +	char notes[PATH_MAX];
> +	u8 build_id[BUILD_ID_SIZE];
> +	char *p;
> +
> +	strlcpy(root_dir, proc_dir, sizeof(root_dir));
> +
> +	p = strrchr(root_dir, '/');
> +	if (!p)
> +		return -1;
> +	*p = '\0';
> +
> +	snprintf(notes, sizeof(notes), "%s/sys/kernel/notes", root_dir);

Please use scnprintf() rather than snprintf().  I can see them in other
places (and on other patches) too.

Thanks,
Namhyung

> +
> +	if (sysfs__read_build_id(notes, build_id, sizeof(build_id)))
> +		return -1;
> +
> +	build_id__sprintf(build_id, sizeof(build_id), sbuildid);
> +
> +	return 0;
> +}
