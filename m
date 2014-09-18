Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbaIRAgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 20:36:15 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36644 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbaIRAgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 20:36:13 -0400
Message-ID: <541A28F6.70702@hitachi.com>
Date: Thu, 18 Sep 2014 09:36:06 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-perf-user@vger.kernel.org, david lerner <dlernerdroid@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH perf/core 1/2] perf probe: Do not access kallsyms
 when analyzing user binaries
References: <20140917084054.3722.73975.stgit@kbuild-f20.novalocal> <20140917205934.GD2770@kernel.org>
In-Reply-To: <20140917205934.GD2770@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/18 5:59), Arnaldo Carvalho de Melo wrote:
> Em Wed, Sep 17, 2014 at 08:40:54AM +0000, Masami Hiramatsu escreveu:
>> Do not access kallsyms to show available variables and
>> show source lines in user binaries.
>> This behavior always requires the root privilege when
>> sysctl sets kernel.kptr_restrict=1, but we don't need
>> it just for analyzing user binaries.
> 
>> +++ b/tools/perf/util/probe-event.c
>> @@ -697,11 +697,11 @@ end:
>>  	return ret;
>>  }
>>  
>> -int show_line_range(struct line_range *lr, const char *module)
>> +int show_line_range(struct line_range *lr, const char *module, bool user)
>>  {
> 
> make -C tools/perf build-test fails for the static build on:
> 
> acme@linux-goap:~/git/linux> cat /etc/os-release
> NAME=openSUSE
> VERSION="12.3 (Dartmouth)"
> VERSION_ID="12.3"
> PRETTY_NAME="openSUSE 12.3 (Dartmouth) (i586)"
> ID=opensuse
> ANSI_COLOR="0;32"
> CPE_NAME="cpe:/o:opensuse:opensuse:12.3"
> acme@linux-goap:~/git/linux> 
> 
> util/probe-event.c:824:5: error: conflicting types for 'show_line_range'
> In file included from util/probe-event.c:45:0:
> util/probe-event.h:131:12: note: previous declaration of
> 'show_line_range' was here
> make[3]: *** [util/probe-event.o] Error 1
> make[2]: *** [all] Error 2
>   test: test -x ./perf
> make[1]: *** [make_static] Error 1
> make: *** [build-test] Error 2
> make: Leaving directory `/home/acme/git/linux/tools/perf'
> acme@linux-goap:~/git/linux>
> 
> And on:
> 
> acme@ubuntu13:~/git/linux$ cat /etc/os-release 
> NAME="Ubuntu"
> VERSION="13.10, Saucy Salamander"
> ID=ubuntu
> ID_LIKE=debian
> PRETTY_NAME="Ubuntu 13.10"
> VERSION_ID="13.10"
> HOME_URL="http://www.ubuntu.com/"
> SUPPORT_URL="http://help.ubuntu.com/"
> BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
> acme@ubuntu13:~/git/linux$ 
> 
>   CC       util/probe-event.o
> util/probe-event.c:824:5: error: conflicting types for ‘show_line_range’
>  int show_line_range(struct line_range *lr __maybe_unused,
>      ^
> In file included from util/probe-event.c:45:0:
> util/probe-event.h:131:12: note: previous declaration of
> ‘show_line_range’ was here
>  extern int show_line_range(struct line_range *lr, const char *module,
>             ^
> make[3]: *** [util/probe-event.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [all] Error 2
>   test: test -x ./perf
> make[1]: *** [make_static] Error 1
> make: *** [build-test] Error 2
> make: Leaving directory `/home/acme/git/linux/tools/perf'
> 
> ---------------------------------------------------------------------
> 
> Probably because I had not installed needed DWARF support libraries and
> you forgot to update this:
> 
> int show_line_range(struct line_range *lr __maybe_unused,
>                     const char *module __maybe_unused)
> {
>         pr_warning("Debuginfo-analysis is not supported.\n");
>         return -ENOSYS;
> }

Oops! Right, I forgot that. Maybe I should move this to the header file
so that I can easily avoid this kind of mistake...

> Fixing it up by adding the missing 'bool user'.

Thank you!



-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


