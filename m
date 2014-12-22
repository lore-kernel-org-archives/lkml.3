Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaLVPN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:13:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:53349 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbaLVPNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:13:25 -0500
Date: Mon, 22 Dec 2014 12:13:21 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: perf: util: color.c:  Remove some unused functions
Message-ID: <20141222151321.GG7644@kernel.org>
References: <1419079865-354-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141222145610.GD29096@krava.brq.redhat.com>
 <20141222150512.GE7644@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141222150512.GE7644@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 22, 2014 at 12:05:12PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Dec 22, 2014 at 03:56:10PM +0100, Jiri Olsa escreveu:
> > On Sat, Dec 20, 2014 at 01:51:05PM +0100, Rickard Strandqvist wrote:
> > > Removes some functions that are not used anywhere:
> > > color_parse_mem() color_parse()
> > > 
> > > This was partially found by using a static code analysis program called cppcheck.
> > 
> > and partially removed ;-)
> > 
> > [jolsa@krava perf]$ make
> >   BUILD:   Doing 'make -j4' parallel build
> >   CC       util/debug.o
> >   CC       util/color.o
> >   CC       util/machine.o
> >   CC       util/map.o
> > util/color.c:8:12: error: ‘parse_color’ defined but not used [-Werror=unused-function]
> >  static int parse_color(const char *name, int len)
> >             ^
> > util/color.c:28:12: error: ‘parse_attr’ defined but not used [-Werror=unused-function]
> >  static int parse_attr(const char *name, int len)
> >             ^
> > cc1: all warnings being treated as errors
> > make[1]: *** [util/color.o] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> > make: *** [all] Error 2
> > 
> > 
> > any clue why this (color name parsing) is in?
> 
> Humm, there is support for changing the TUI colors in ~/.perfconfig, but
> probably it doesn't uses those functions?

void ui_browser__init(void)
{
        int i = 0;

        perf_config(ui_browser__color_config, NULL);

        while (ui_browser__colorsets[i].name) {
                struct ui_browser_colorset *c = &ui_browser__colorsets[i++];
                sltt_set_color(c->colorset, c->name, c->fg, c->bg);
        }

        annotate_browser__init();
}

And ui_browser__color_config does really simple parsing, using straight
away the color strings provided in the config file.

Looking again, we could even use those, after adapting it to what
libslang expects, not what ncurses do, but I haven't checked, perhaps
libslang will do that validation for us, in the meantime, I'm applying
the patch.

- Arnaldo
