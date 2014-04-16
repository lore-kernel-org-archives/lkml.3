Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161493AbaDPO0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:26:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38309 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161377AbaDPO0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:26:01 -0400
Date: Wed, 16 Apr 2014 15:24:05 +0100
From: Will Deacon <will.deacon@arm.com>
To: Adrien BAK <adrien.bak@metascale.org>
Cc: "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Error reporting improvement
Message-ID: <20140416142405.GC2005@arm.com>
References: <534E3215.2060306@metascale.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534E3215.2060306@metascale.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrien,

On Wed, Apr 16, 2014 at 08:32:37AM +0100, Adrien BAK wrote:
> In the current version, when using perf record, if something goes wrong in
> tools/perf/builtin-record.c:375  session = perf_session__new(file, 
> false, NULL);
> The error message:
> "Not enough memory for reading per file header"
> is issued. This error message seems to be outdated and is not very helpful.
> This patch propose to replace this error message by
> "Perf session creation failed"
> 
> I believe this issue has been brought to lkml :
> https://lkml.org/lkml/2014/2/24/458
> although this patch only tackle a (small) part of the issue.
> 
> Additionnaly, this patch improves error reporting in
> tools/perf/util/data.c open_file_write
> Currently, if the call to open fails, the user is unaware of it.
> This patch logs the error, before returning the error code to the caller.
> 
> Signed-off-by: Adrien BAK <adrien.bak@metascale.org>

Whilst this patch (admittedly) only solves part of the problem, I think it
makes the error I encountered a lot easier to understand.

Thanks,

  Reported-by: Will Deacon <will.deacon@arm.com>

Will

> 
> ---
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index eb524f9..8ce62ef 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -374,7 +374,7 @@ static int __cmd_record(struct record *rec, int 
> argc, const char **argv)
> 
>       session = perf_session__new(file, false, NULL);
>       if (session == NULL) {
> -        pr_err("Not enough memory for reading perf file header\n");
> +        pr_err("Perf session creation failed.\n");
>           return -1;
>       }
> 
> diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
> index 1fbcd8b..ff2ced7 100644
> --- a/tools/perf/util/data.c
> +++ b/tools/perf/util/data.c
> @@ -86,10 +86,16 @@ static int open_file_read(struct perf_data_file *file)
> 
>   static int open_file_write(struct perf_data_file *file)
>   {
> +    int fd;
>       if (check_backup(file))
>           return -1;
> 
> -    return open(file->path, O_CREAT|O_RDWR|O_TRUNC, S_IRUSR|S_IWUSR);
> +    fd = open(file->path, O_CREAT|O_RDWR|O_TRUNC, S_IRUSR|S_IWUSR);
> +
> +    if (fd < 0)
> +        pr_err("failed to open %s : %s\n", file->path, strerror(errno));
> +
> +    return fd;
>   }
> 
>   static int open_file(struct perf_data_file *file)
> 
> 
