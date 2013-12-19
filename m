Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab3LSHgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:36:05 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52091 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3LSHgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:36:03 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <529DDDAF.1000202@redhat.com>
References: <1382101019-23563-1-git-send-email-jmarchan@redhat.com>
	<1382101019-23563-2-git-send-email-jmarchan@redhat.com>
	<529DDDAF.1000202@redhat.com>
Date: Wed, 18 Dec 2013 23:36:02 -0800
Message-ID: <CAOesGMigOZzAEYV=SJNTd+cm6LcepxOek3ZvBrFCc+WT94OkzA@mail.gmail.com>
Subject: Re: [PATCH v5] mm: add overcommit_kbytes sysctl variable
From: Olof Johansson <olof@lixom.net>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dave.hansen@intel.com, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 3, 2013 at 5:33 AM, Jerome Marchand <jmarchan@redhat.com> wrote:

[...]

> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 34a6047..7877929 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -97,6 +97,7 @@
>  /* External variables not in a header file. */
>  extern int sysctl_overcommit_memory;
>  extern int sysctl_overcommit_ratio;
> +extern unsigned long sysctl_overcommit_kbytes;
>  extern int max_threads;
>  extern int suid_dumpable;
>  #ifdef CONFIG_COREDUMP
> @@ -1128,7 +1129,14 @@ static struct ctl_table vm_table[] = {
>                 .data           = &sysctl_overcommit_ratio,
>                 .maxlen         = sizeof(sysctl_overcommit_ratio),
>                 .mode           = 0644,
> -               .proc_handler   = proc_dointvec,
> +               .proc_handler   = overcommit_ratio_handler,
> +       },
> +       {
> +               .procname       = "overcommit_kbytes",
> +               .data           = &sysctl_overcommit_kbytes,
> +               .maxlen         = sizeof(sysctl_overcommit_kbytes),
> +               .mode           = 0644,
> +               .proc_handler   = overcommit_kbytes_handler,
>         },
>         {
>                 .procname       = "page-cluster",
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 834b2d7..b25167d 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -86,6 +86,7 @@ EXPORT_SYMBOL(vm_get_page_prot);
>
>  int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;  /* heuristic overcommit */
>  int sysctl_overcommit_ratio __read_mostly = 50;        /* default is 50% */
> +unsigned long sysctl_overcommit_kbytes __read_mostly = 0;
>  int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
>  unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
>  unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
> @@ -95,6 +96,30 @@ unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
>   */
>  struct percpu_counter vm_committed_as ____cacheline_aligned_in_smp;
>
> +int overcommit_ratio_handler(struct ctl_table *table, int write,
> +                            void __user *buffer, size_t *lenp,
> +                            loff_t *ppos)
> +{
> +       int ret;
> +
> +       ret = proc_dointvec(table, write, buffer, lenp, ppos);
> +       if (ret == 0 && write)
> +               sysctl_overcommit_kbytes = 0;
> +       return ret;
> +}
> +
> +int overcommit_kbytes_handler(struct ctl_table *table, int write,
> +                            void __user *buffer, size_t *lenp,
> +                            loff_t *ppos)
> +{
> +       int ret;
> +
> +       ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
> +       if (ret == 0 && write)
> +               sysctl_overcommit_ratio = 0;
> +       return ret;
> +}
> +
>  /*
>   * The global memory commitment made in the system can be a metric
>   * that can be used to drive ballooning decisions when Linux is hosted
> diff --git a/mm/nommu.c b/mm/nommu.c
> index fec093a..319ab8f 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -60,6 +60,7 @@ unsigned long highest_memmap_pfn;
>  struct percpu_counter vm_committed_as;
>  int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
>  int sysctl_overcommit_ratio = 50; /* default is 50% */
> +unsigned long sysctl_overcommit_kbytes __read_mostly = 0;
>  int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
>  int sysctl_nr_trim_pages = CONFIG_NOMMU_INITIAL_TRIM_EXCESS;
>  unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */

You add the variable on the nommu side, but not the functions to
handle the sysctl. So things fail to compile on !MMU builds with:

kernel/built-in.o:(.data+0x4e0): undefined reference to
`overcommit_ratio_handler'
kernel/built-in.o:(.data+0x504): undefined reference to
`overcommit_kbytes_handler'

I don't know mm well enough to tell if copying and pasting the code
over verbatim is the right thing to do, or if there's a preferred
other location (that is shared) to move it to?


-Olof
