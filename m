Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3LZOWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:22:55 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:39916 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3LZOWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:22:54 -0500
Date: Thu, 26 Dec 2013 11:22:48 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH -tip v2 1/2] [CLEANUP] perf-probe: Expand given path to
 absolute path
Message-ID: <20131226142248.GE30980@ghostprotocols.net>
References: <20131226054148.22364.25224.stgit@kbuild-fedora.novalocal>
 <20131226054150.22364.12187.stgit@kbuild-fedora.novalocal>
 <52BC39D6.3090908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52BC39D6.3090908@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 26, 2013 at 09:14:46AM -0500, David Ahern escreveu:
> On 12/26/13, 12:41 AM, Masami Hiramatsu wrote:
> >@@ -180,7 +181,20 @@ static int opt_set_target(const struct option *opt, const char *str,
> >  		else
> >  			return ret;
> >
> >-		params.target = str;
> >+		/* Expand given path to absolute path, except for modulename */
> >+		if (params.uprobes || strchr(str, '/')) {
> >+			tmp = realpath(str, NULL);
> >+			if (!tmp) {
> >+				pr_warning("Failed to find the path of %s.\n",
> >+					   str);
> 
> That error message will be misleading if it is generated. How about:
>     Failed to get the absolute path of %s: %d\n", str, errno.

Changed it to:

 pr_warning("Failed to get the absolute path of %s: %m\n", str);

 
> >+				return ret;
> >+			}
> >+		} else {
> >+			tmp = strdup(str);
> >+			if (!tmp)
> >+				return -ENOMEM;
> >+		}
> >+		params.target = tmp;
> 
> When is params.target freed?

> David
