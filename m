Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277AbaFQVNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:13:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:23419 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965215AbaFQVNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:13:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,496,1400050800"; 
   d="scan'208";a="557026021"
Date: Tue, 17 Jun 2014 14:13:02 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 1/2] tmon: Check log file for common secuirty issues
Message-ID: <20140617141302.7f5b0434@ultegra>
In-Reply-To: <1403035509-31815-2-git-send-email-nhorman@tuxdriver.com>
References: <1403035509-31815-1-git-send-email-nhorman@tuxdriver.com>
	<1403035509-31815-2-git-send-email-nhorman@tuxdriver.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014 16:05:08 -0400
Neil Horman <nhorman@tuxdriver.com> wrote:

> The tmon logging system blindly opens its log file on a static path,
> making it very easy for someone to redirect that log information to
> inappropriate places or overwrite other users data.  Do some easy
> checking to make sure we're not logging to a symlink or a file owned
> by another user.
> 
Acked-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Zhang Rui <rui.zhang@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  tools/thermal/tmon/tmon.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/tools/thermal/tmon/tmon.c b/tools/thermal/tmon/tmon.c
> index b30f531..059e0be 100644
> --- a/tools/thermal/tmon/tmon.c
> +++ b/tools/thermal/tmon/tmon.c
> @@ -142,6 +142,7 @@ static void start_syslog(void)
>  static void prepare_logging(void)
>  {
>  	int i;
> +	struct stat logstat;
>  
>  	if (!logging)
>  		return;
> @@ -152,6 +153,29 @@ static void prepare_logging(void)
>  		return;
>  	}
>  
> +	if (lstat(TMON_LOG_FILE, &logstat) < 0) {
> +		syslog(LOG_ERR, "Unable to stat log file %s\n",
> TMON_LOG_FILE);
> +		fclose(tmon_log);
> +		tmon_log = NULL;
> +		return;
> +	}
> +
> +	/* The log file must be a regular file owned by us */
> +	if (S_ISLNK(logstat.st_mode)) {
> +		syslog(LOG_ERR, "Log file is a symlink.  Will not
> log\n");
> +		fclose(tmon_log);
> +		tmon_log = NULL;
> +		return;
> +	}
> +
> +	if (logstat.st_uid != getuid()) {
> +		syslog(LOG_ERR, "We don't own the log file.  Not
> logging\n");
> +		fclose(tmon_log);
> +		tmon_log = NULL;
> +		return;
> +	}
> +
> +
>  	fprintf(tmon_log, "#----------- THERMAL SYSTEM CONFIG
> -------------\n"); for (i = 0; i < ptdata.nr_tz_sensor; i++) {
>  		char binding_str[33]; /* size of long + 1 */

[Jacob Pan]

-- 
Thanks,

Jacob
