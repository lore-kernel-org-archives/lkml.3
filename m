Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3GQVor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 17:44:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59212 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab3GQVop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 17:44:45 -0400
Date: Wed, 17 Jul 2013 23:44:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, celinux-dev@lists.celinuxforum.org,
        linux-arm-kernel@lists.infradead.org, hyojun.im@lge.com,
        chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
Message-ID: <20130717214441.GB4454@pd.tnic>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
 <20130716004727.b60b2c96.akpm@linux-foundation.org>
 <20130716005611.e4ccab02.akpm@linux-foundation.org>
 <201307161008.07643.yann.morin.1998@free.fr>
 <20130716180408.GA19863@merkur.ravnborg.org>
 <20130717211649.GA5619@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130717211649.GA5619@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 11:16:49PM +0200, Sam Ravnborg wrote:
> +
> +static void exec_command(const char *command, struct symbol *sym)
> +{
> +	char buffer[2048];
> +	FILE *stream;

Just some indentation level saving:

> +
> +	stream = popen(command, "r");
> +
> +	if (stream != NULL) {

	if (!stream) {
		menu_warn(current_entry, "command '%s' failed to execute", command);
		return;
	}

and the rest starts one level less to the right:

	if (fgets(buffer, sizeof(buffer), stream) != NULL) {
		int i;

		buffer[sizeof(buffer) - 1] = '\0';

and so on...

> +
> +			/* Drop any trialing newlines */
> +			i = strlen(buffer);
> +			while (i > 0 && buffer[i - 1] == '\n') {
> +				buffer[i - 1] = '\0';
> +				i--;
> +			}
> +			/* Validate the output of the command */
> +			if (strlen(buffer) == 0) {
> +				menu_warn(current_entry,
> +				          "command '%s' - invalid (empty?) return value: \"%s\"",
> +				          command, buffer);
> +				return;
> +			}
> +
> +			menu_warn(current_entry, "default: %s", buffer);
> +			sym_add_default(sym, buffer);
> +		} else {
> +			menu_warn(current_entry, "command '%s' - empty return value", command);
> +		}
> +		pclose(stream);
> +	} else {
> +		menu_warn(current_entry, "command '%s' failed to execute", command);
> +	}
> +}

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
