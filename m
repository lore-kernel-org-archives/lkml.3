Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaIWNBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:01:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbaIWNBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:01:47 -0400
Message-ID: <54216F39.9030902@suse.cz>
Date: Tue, 23 Sep 2014 15:01:45 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Alexis Berlemont <alexis.berlemont@gmail.com>
CC: linux-kernel@vger.kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        mingo@kernel.org, sam@ravnborg.org, namhyung@kernel.org
Subject: Re: [PATCH 01/15] kbuild: add support of custom paths for "auto.conf*"
 files
References: <1411422796-27049-1-git-send-email-alexis.berlemont@gmail.com> <1411422796-27049-2-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <1411422796-27049-2-git-send-email-alexis.berlemont@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-22 23:53, Alexis Berlemont wrote:
> In the scripts/Makefile.build, use KCONFIG_AUTOCONFIG to include a
> custom path for the "auto.conf" file.
> 
> The "*conf" programs were modified so as to work with the environment
> variable KCONFIG_AUTOCONFIG.
> ---
>  scripts/Makefile.build     |  3 ++-
>  scripts/kconfig/confdata.c | 27 ++++++++++++++++++++++++++-
>  scripts/kconfig/lkc.h      |  1 +
>  3 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index bf3e677..ef60769 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -31,7 +31,8 @@ subdir-asflags-y :=
>  subdir-ccflags-y :=
>  
>  # Read auto.conf if it exists, otherwise ignore
> --include include/config/auto.conf
> +kconfig-autoconfig := $(if $(KCONFIG_AUTOCONFIG),$(KCONFIG_AUTOCONFIG),include/config/auto.conf)
> +-include $(kconfig-autoconfig)
>  
>  include scripts/Kbuild.include
>  
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index f88d90f..d4d8920 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -75,6 +75,27 @@ const char *conf_get_autoconfig_name(void)
>  	return name ? name : "include/config/auto.conf";
>  }
>  
> +#define PATH_MAXLENGTH 4096
> +const char *conf_get_autoconfigdep_name(void)
> +{
> +	static char res_value[PATH_MAXLENGTH];
> +
> +	char *name = getenv("KCONFIG_AUTOCONFIG");
> +
> +	if (name == NULL)
> +		name = "include/config/auto.conf.cmd";

This will result in "include/config/auto.conf.cmd.cmd". Better simplify
it to name = conf_get_autoconfig_name().


> +	if (strlen(name) > PATH_MAXLENGTH - 5)
> +		name = NULL;
> +	else {
> +		res_value[0] = 0;

This assignment is superfluous.


> +		strncpy(res_value, name, PATH_MAXLENGTH);
> +		strcat(res_value, ".cmd");
> +		name = res_value;

Michal

