Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaDFMHo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 08:07:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbaDFMHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 08:07:42 -0400
Date: Sun, 6 Apr 2014 14:07:28 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] tools/perf: allow overriding sysfs and proc finding with
 env var
Message-ID: <20140406120728.GA1164@krava.brq.redhat.com>
References: <1396641598-525-1-git-send-email-cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396641598-525-1-git-send-email-cody@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 12:59:25PM -0700, Cody P Schafer wrote:
> SYSFS_PATH and PROC_PATH environment variables now let the user override
> the detection of sysfs and proc locations for testing purposes.

seems usefull, but this code was moved to tools/lib/api/fs/fs.c

please rebase to the latest Arnaldo's perf/core branch
(git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux)

thanks,
jirka

> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  tools/perf/util/fs.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/tools/perf/util/fs.c b/tools/perf/util/fs.c
> index f5be1f2..dccbd26 100644
> --- a/tools/perf/util/fs.c
> +++ b/tools/perf/util/fs.c
> @@ -91,8 +91,44 @@ static bool fs__check_mounts(struct fs *fs)
>  	return false;
>  }
>  
> +static void mem_toupper(char *f, size_t len)
> +{
> +	while (len) {
> +		*f = toupper(*f);
> +		f++;
> +		len--;
> +	}
> +}
> +
> +/*
> + * Check for "NAME_PATH" environment variable to override fs location (for
> + * testing). This matches the recommendation in Documentation/sysfs-rules.txt
> + * for SYSFS_PATH.
> + */
> +static bool fs__env_override(struct fs *fs)
> +{
> +	char *override_path;
> +	size_t name_len = strlen(fs->name);
> +	/* name + "_PATH" + '\0' */
> +	char upper_name[name_len + 5 + 1];
> +	memcpy(upper_name, fs->name, name_len);
> +	mem_toupper(upper_name, name_len);
> +	strcpy(&upper_name[name_len], "_PATH");
> +
> +	override_path = getenv(upper_name);
> +	if (!override_path)
> +		return false;
> +
> +	fs->found = true;
> +	strcpy(fs->path, override_path);

please use strncpy with size of fs->path
