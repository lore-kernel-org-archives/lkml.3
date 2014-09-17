Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbaIQU7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:59:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:56909 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756739AbaIQU7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:59:41 -0400
Date: Wed, 17 Sep 2014 17:59:34 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-perf-user@vger.kernel.org, david lerner <dlernerdroid@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH perf/core 1/2] perf probe: Do not access kallsyms when
 analyzing user binaries
Message-ID: <20140917205934.GD2770@kernel.org>
References: <20140917084054.3722.73975.stgit@kbuild-f20.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140917084054.3722.73975.stgit@kbuild-f20.novalocal>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 17, 2014 at 08:40:54AM +0000, Masami Hiramatsu escreveu:
> Do not access kallsyms to show available variables and
> show source lines in user binaries.
> This behavior always requires the root privilege when
> sysctl sets kernel.kptr_restrict=1, but we don't need
> it just for analyzing user binaries.

> +++ b/tools/perf/util/probe-event.c
> @@ -697,11 +697,11 @@ end:
>  	return ret;
>  }
>  
> -int show_line_range(struct line_range *lr, const char *module)
> +int show_line_range(struct line_range *lr, const char *module, bool user)
>  {

make -C tools/perf build-test fails for the static build on:

acme@linux-goap:~/git/linux> cat /etc/os-release
NAME=openSUSE
VERSION="12.3 (Dartmouth)"
VERSION_ID="12.3"
PRETTY_NAME="openSUSE 12.3 (Dartmouth) (i586)"
ID=opensuse
ANSI_COLOR="0;32"
CPE_NAME="cpe:/o:opensuse:opensuse:12.3"
acme@linux-goap:~/git/linux> 

util/probe-event.c:824:5: error: conflicting types for 'show_line_range'
In file included from util/probe-event.c:45:0:
util/probe-event.h:131:12: note: previous declaration of
'show_line_range' was here
make[3]: *** [util/probe-event.o] Error 1
make[2]: *** [all] Error 2
  test: test -x ./perf
make[1]: *** [make_static] Error 1
make: *** [build-test] Error 2
make: Leaving directory `/home/acme/git/linux/tools/perf'
acme@linux-goap:~/git/linux>

And on:

acme@ubuntu13:~/git/linux$ cat /etc/os-release 
NAME="Ubuntu"
VERSION="13.10, Saucy Salamander"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 13.10"
VERSION_ID="13.10"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
acme@ubuntu13:~/git/linux$ 

  CC       util/probe-event.o
util/probe-event.c:824:5: error: conflicting types for ‘show_line_range’
 int show_line_range(struct line_range *lr __maybe_unused,
     ^
In file included from util/probe-event.c:45:0:
util/probe-event.h:131:12: note: previous declaration of
‘show_line_range’ was here
 extern int show_line_range(struct line_range *lr, const char *module,
            ^
make[3]: *** [util/probe-event.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [all] Error 2
  test: test -x ./perf
make[1]: *** [make_static] Error 1
make: *** [build-test] Error 2
make: Leaving directory `/home/acme/git/linux/tools/perf'

---------------------------------------------------------------------

Probably because I had not installed needed DWARF support libraries and
you forgot to update this:

int show_line_range(struct line_range *lr __maybe_unused,
                    const char *module __maybe_unused)
{
        pr_warning("Debuginfo-analysis is not supported.\n");
        return -ENOSYS;
}


Fixing it up by adding the missing 'bool user'.

- Arnaldo
