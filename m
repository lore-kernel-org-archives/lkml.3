Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab3GQVQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 17:16:53 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:39735 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab3GQVQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 17:16:52 -0400
Date: Wed, 17 Jul 2013 23:16:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, celinux-dev@lists.celinuxforum.org,
        linux-arm-kernel@lists.infradead.org, hyojun.im@lge.com,
        chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, Borislav Petkov <bp@alien8.de>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the
	new streaming format
Message-ID: <20130717211649.GA5619@merkur.ravnborg.org>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com> <20130716004727.b60b2c96.akpm@linux-foundation.org> <20130716005611.e4ccab02.akpm@linux-foundation.org> <201307161008.07643.yann.morin.1998@free.fr> <20130716180408.GA19863@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716180408.GA19863@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> We could extend the symbol option part to retreive values from a binary.
> Something like this:
> 
> config FOOBAR
>         bool
>         option exec="true"
> 
> FOOBAR would assume the value "y" if the command true has exit code == 0, otherwise "n".
> And similar conversions for other types.
> 
> This only extendt Kconfig slightly - using an already present method to import
> external values.
> 
> The drawback I see with this approach is that we may execute a lot of small programs
> where the value is never used.

Following is a quick patch implmenting this idea.
You need to run gperf manually to enable this.

"gperf -C scripts/kconfig/zconf.gperf > scripts/kconfig/zconf.hash.c"

I did not figure out how to use the built-in rules to generate this file :-(

I have tested this lightly - as we should discuss if this is a viable way forward.
For now I used popen() - so return value of the executed program are ignored.

To test this I used:

config FOOBAR
	bool
	option exec="echo y"

config FOOBAR_SELECTOR
	bool
	default FOOBAR

Nothing fancy - but it shows the idea.

	Sam


diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index df198a5..a68258b 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -133,6 +133,7 @@ enum prop_type {
 	P_SELECT,   /* select BAR */
 	P_RANGE,    /* range 7..100 (for a symbol) */
 	P_ENV,      /* value from environment variable */
+	P_EXEC,     /* value from executable (using symbol option) */
 	P_SYMBOL,   /* where a symbol is defined */
 };
 
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index 09f4edf..371f73b 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -61,6 +61,7 @@ enum conf_def_mode {
 #define T_OPT_MODULES		1
 #define T_OPT_DEFCONFIG_LIST	2
 #define T_OPT_ENV		3
+#define T_OPT_EXEC		4
 
 struct kconf_id {
 	int name;
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 7e233a6..cfa7aaa 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -213,6 +213,9 @@ void menu_add_option(int token, char *arg)
 	case T_OPT_ENV:
 		prop_add_env(arg);
 		break;
+	case T_OPT_EXEC:
+		prop_add_exec(arg);
+		break;
 	}
 }
 
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index d550300..b7179a6 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -1331,6 +1331,8 @@ const char *prop_get_type_name(enum prop_type type)
 		return "prompt";
 	case P_ENV:
 		return "env";
+	case P_EXEC:
+		return "exec";
 	case P_COMMENT:
 		return "comment";
 	case P_MENU:
@@ -1379,3 +1381,56 @@ static void prop_add_env(const char *env)
 	else
 		menu_warn(current_entry, "environment variable %s undefined", env);
 }
+
+static void exec_command(const char *command, struct symbol *sym)
+{
+	char buffer[2048];
+	FILE *stream;
+
+	stream = popen(command, "r");
+
+	if (stream != NULL) {
+		if (fgets(buffer, sizeof(buffer), stream) != NULL) {
+			int i;
+
+			buffer[sizeof(buffer) - 1] = '\0';
+
+			/* Drop any trialing newlines */
+			i = strlen(buffer);
+			while (i > 0 && buffer[i - 1] == '\n') {
+				buffer[i - 1] = '\0';
+				i--;
+			}
+			/* Validate the output of the command */
+			if (strlen(buffer) == 0) {
+				menu_warn(current_entry,
+				          "command '%s' - invalid (empty?) return value: \"%s\"",
+				          command, buffer);
+				return;
+			}
+
+			menu_warn(current_entry, "default: %s", buffer);
+			sym_add_default(sym, buffer);
+		} else {
+			menu_warn(current_entry, "command '%s' - empty return value", command);
+		}
+		pclose(stream);
+	} else {
+		menu_warn(current_entry, "command '%s' failed to execute", command);
+	}
+}
+
+static void prop_add_exec(const char *command)
+{
+	struct property *prop;
+	struct symbol *sym;
+
+	sym = current_entry->sym;
+	sym->flags |= SYMBOL_AUTO;
+
+	prop = prop_alloc(P_EXEC, sym);
+	prop->expr = expr_alloc_symbol(sym_lookup(command, SYMBOL_CONST));
+
+	exec_command(command, sym);
+}
+
diff --git a/scripts/kconfig/zconf.gperf b/scripts/kconfig/zconf.gperf
index f14ab41..02c6a59 100644
--- a/scripts/kconfig/zconf.gperf
+++ b/scripts/kconfig/zconf.gperf
@@ -44,4 +44,5 @@ on,		T_ON,		TF_PARAM
 modules,	T_OPT_MODULES,	TF_OPTION
 defconfig_list,	T_OPT_DEFCONFIG_LIST,TF_OPTION
 env,		T_OPT_ENV,	TF_OPTION
+exec,		T_OPT_EXEC,	TF_OPTION
 %%
