Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaBXWT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:19:28 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:59297 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaBXWTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:19:25 -0500
Date: Mon, 24 Feb 2014 14:19:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dwight Engen <dwight.engen@oracle.com>, Eric Paris <eparis@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Michal Hocko <mhocko@suse.cz>,
        Michal Marek <mmarek@suse.cz>, Mike Frysinger <vapier@gentoo.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Rob Landley <rob@landley.net>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-doc@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: Make allnoconfig disable options behind
 EMBEDDED and EXPERT
Message-ID: <20140224221920.GB8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140224022021.GA12665@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224022021.GA12665@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022422-9332-0000-0000-00000335AB49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 06:20:26PM -0800, Josh Triplett wrote:
> "make allnoconfig" exists to ease testing of minimal configurations.
> Documentation/SubmitChecklist includes a note to test with allnoconfig.
> This helps catch missing dependencies on common-but-not-required
> functionality, which might otherwise go unnoticed.
> 
> However, allnoconfig still leaves many symbols enabled, because they're
> hidden behind CONFIG_EMBEDDED or CONFIG_EXPERT.  For instance,
> allnoconfig still has CONFIG_PRINTK and CONFIG_BLOCK enabled, so drivers
> don't typically get build-tested with those disabled.
> 
> To address this, introduce a new Kconfig option "allnoconfig_y", used on
> symbols which only exist to hide other symbols.  Set it on
> CONFIG_EMBEDDED (which then selects CONFIG_EXPERT).  allnoconfig will
> then disable all the symbols hidden behind those.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  Documentation/kbuild/kconfig-language.txt |  4 ++++
>  init/Kconfig                              |  1 +
>  scripts/kconfig/confdata.c                |  5 ++++-
>  scripts/kconfig/expr.h                    |  3 +++
>  scripts/kconfig/lkc.h                     |  1 +
>  scripts/kconfig/menu.c                    |  3 +++
>  scripts/kconfig/zconf.gperf               |  1 +
>  scripts/kconfig/zconf.hash.c_shipped      | 13 ++++++++-----
>  8 files changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
> index c420676..350f733 100644
> --- a/Documentation/kbuild/kconfig-language.txt
> +++ b/Documentation/kbuild/kconfig-language.txt
> @@ -157,6 +157,10 @@ applicable everywhere (see syntax).
>      to the build environment (if this is desired, it can be done via
>      another symbol).
> 
> +  - "allnoconfig_y"
> +    This declares the symbol as one that should have the value y when
> +    using "allnoconfig". Used for symbols that hide other symbols.
> +
>  Menu dependencies
>  -----------------
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 009a797..238aafb 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1455,6 +1455,7 @@ config PCI_QUIRKS
> 
>  config EMBEDDED
>  	bool "Embedded system"
> +	option allnoconfig_y
>  	select EXPERT
>  	help
>  	  This option should be enabled if compiling the kernel for
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index 87f7238..f88d90f 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -1178,7 +1178,10 @@ bool conf_set_all_new_symbols(enum conf_def_mode mode)
>  				sym->def[S_DEF_USER].tri = mod;
>  				break;
>  			case def_no:
> -				sym->def[S_DEF_USER].tri = no;
> +				if (sym->flags & SYMBOL_ALLNOCONFIG_Y)
> +					sym->def[S_DEF_USER].tri = yes;
> +				else
> +					sym->def[S_DEF_USER].tri = no;
>  				break;
>  			case def_random:
>  				sym->def[S_DEF_USER].tri = no;
> diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
> index ba663e1..412ea8a 100644
> --- a/scripts/kconfig/expr.h
> +++ b/scripts/kconfig/expr.h
> @@ -109,6 +109,9 @@ struct symbol {
>  /* choice values need to be set before calculating this symbol value */
>  #define SYMBOL_NEED_SET_CHOICE_VALUES  0x100000
> 
> +/* Set symbol to y if allnoconfig; used for symbols that hide others */
> +#define SYMBOL_ALLNOCONFIG_Y 0x200000
> +
>  #define SYMBOL_MAXLENGTH	256
>  #define SYMBOL_HASHSIZE		9973
> 
> diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
> index 09f4edf..d5daa7a 100644
> --- a/scripts/kconfig/lkc.h
> +++ b/scripts/kconfig/lkc.h
> @@ -61,6 +61,7 @@ enum conf_def_mode {
>  #define T_OPT_MODULES		1
>  #define T_OPT_DEFCONFIG_LIST	2
>  #define T_OPT_ENV		3
> +#define T_OPT_ALLNOCONFIG_Y	4
> 
>  struct kconf_id {
>  	int name;
> diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
> index db1512a..3ac2c9c 100644
> --- a/scripts/kconfig/menu.c
> +++ b/scripts/kconfig/menu.c
> @@ -217,6 +217,9 @@ void menu_add_option(int token, char *arg)
>  	case T_OPT_ENV:
>  		prop_add_env(arg);
>  		break;
> +	case T_OPT_ALLNOCONFIG_Y:
> +		current_entry->sym->flags |= SYMBOL_ALLNOCONFIG_Y;
> +		break;
>  	}
>  }
> 
> diff --git a/scripts/kconfig/zconf.gperf b/scripts/kconfig/zconf.gperf
> index f14ab41..b6ac02d 100644
> --- a/scripts/kconfig/zconf.gperf
> +++ b/scripts/kconfig/zconf.gperf
> @@ -44,4 +44,5 @@ on,		T_ON,		TF_PARAM
>  modules,	T_OPT_MODULES,	TF_OPTION
>  defconfig_list,	T_OPT_DEFCONFIG_LIST,TF_OPTION
>  env,		T_OPT_ENV,	TF_OPTION
> +allnoconfig_y,	T_OPT_ALLNOCONFIG_Y,TF_OPTION
>  %%
> diff --git a/scripts/kconfig/zconf.hash.c_shipped b/scripts/kconfig/zconf.hash.c_shipped
> index 40df000..c77a8ef 100644
> --- a/scripts/kconfig/zconf.hash.c_shipped
> +++ b/scripts/kconfig/zconf.hash.c_shipped
> @@ -55,10 +55,10 @@ kconf_id_hash (register const char *str, register unsigned int len)
>        73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
>        73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
>        73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
> -      73, 73, 73, 73, 73, 73, 73, 73, 25, 25,
> +      73, 73, 73, 73, 73, 73, 73,  5, 25, 25,
>         0,  0,  0,  5,  0,  0, 73, 73,  5,  0,
>        10,  5, 45, 73, 20, 20,  0, 15, 15, 73,
> -      20, 73, 73, 73, 73, 73, 73, 73, 73, 73,
> +      20,  5, 73, 73, 73, 73, 73, 73, 73, 73,
>        73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
>        73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
>        73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
> @@ -106,6 +106,7 @@ struct kconf_id_strings_t
>      char kconf_id_strings_str23[sizeof("mainmenu")];
>      char kconf_id_strings_str25[sizeof("menuconfig")];
>      char kconf_id_strings_str27[sizeof("modules")];
> +    char kconf_id_strings_str28[sizeof("allnoconfig_y")];
>      char kconf_id_strings_str29[sizeof("menu")];
>      char kconf_id_strings_str31[sizeof("select")];
>      char kconf_id_strings_str32[sizeof("comment")];
> @@ -141,6 +142,7 @@ static const struct kconf_id_strings_t kconf_id_strings_contents =
>      "mainmenu",
>      "menuconfig",
>      "modules",
> +    "allnoconfig_y",
>      "menu",
>      "select",
>      "comment",
> @@ -170,7 +172,7 @@ kconf_id_lookup (register const char *str, register unsigned int len)
>  {
>    enum
>      {
> -      TOTAL_KEYWORDS = 32,
> +      TOTAL_KEYWORDS = 33,
>        MIN_WORD_LENGTH = 2,
>        MAX_WORD_LENGTH = 14,
>        MIN_HASH_VALUE = 2,
> @@ -219,7 +221,8 @@ kconf_id_lookup (register const char *str, register unsigned int len)
>        {-1},
>  #line 44 "scripts/kconfig/zconf.gperf"
>        {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str27,	T_OPT_MODULES,	TF_OPTION},
> -      {-1},
> +#line 47 "scripts/kconfig/zconf.gperf"
> +      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str28,	T_OPT_ALLNOCONFIG_Y,TF_OPTION},
>  #line 16 "scripts/kconfig/zconf.gperf"
>        {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str29,		T_MENU,		TF_COMMAND},
>        {-1},
> @@ -282,5 +285,5 @@ kconf_id_lookup (register const char *str, register unsigned int len)
>      }
>    return 0;
>  }
> -#line 47 "scripts/kconfig/zconf.gperf"
> +#line 48 "scripts/kconfig/zconf.gperf"
> 
> -- 
> 1.9.0
> 

