Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab3D0Gyn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 02:54:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab3D0Gyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 02:54:41 -0400
Message-ID: <517B762D.8030409@suse.cz>
Date: Sat, 27 Apr 2013 08:54:37 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: sedat.dilek@gmail.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 26
References: <20130426180357.7599d1b6b7965470905dcdf3@canb.auug.org.au> <CA+icZUWt_W5FUQgQ2TFoQU0df+sAbxZZE8AcD16T3f_fiTD9DQ@mail.gmail.com> <517A4FC1.3070605@suse.cz> <20130426100435.GA28733@sepie.suse.cz> <CA+icZUVOfB2JuL1xh1EO1hTP_eOkntYFKsUJ0Zp6VZqn09NABA@mail.gmail.com> <CA+icZUWNVEsiTs6u_2R9krb45ub4t-pZj_VEPRmrX2c4DzwfmA@mail.gmail.com> <CA+icZUXSsqN1iE3ttQakvpZqG-oOL9NR6RMUezB7LGeUw3d00Q@mail.gmail.com> <517A6033.5060103@suse.cz> <517A615D.9020400@suse.cz> <20130426220131.GC5100@free.fr>
In-Reply-To: <20130426220131.GC5100@free.fr>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 27.4.2013 00:01, Yann E. MORIN napsal(a):
> Michal, Sedat, All,
> 
> On Fri, Apr 26, 2013 at 01:13:33PM +0200, Michal Marek wrote:
>> On 26.4.2013 13:08, Michal Marek wrote:
>>> On 26.4.2013 12:49, Sedat Dilek wrote:
>>>> With reverting all kbuild-next commits I was able to build again.
>>>>
>>>>       Revert "kconfig: implement KCONFIG_PROBABILITY for randconfig"
>>>>       Revert "kconfig: allow specifying the seed for randconfig"
>>>>       Revert "kconfig: fix randomising choice entries in presence of
>>>> KCONFIG_ALLCONFIG"
>>>>       Revert "kconfig: do not override symbols already set"
>>>>       Revert "kconfig: fix randconfig tristate detection"
>>>
>>> I did the same, then applied all the kconfig commits once more and did a
>>> git bisect with this script:
>>>
>>> #!/bin/sh
>>>
>>> cp config-bad .config
>>> make silentoldconfig </dev/null
>>>
>>> This resulted in
>>>
>>> 7ded2624f8988bd22819a60a6000ba6b7091db89 is the first bad commit
>>> commit 7ded2624f8988bd22819a60a6000ba6b7091db89
>>> Author: Yann E. MORIN <yann.morin.1998@free.fr>
>>> Date:   Sun Mar 10 16:34:10 2013 +0100
>>>
>>>     kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG
>>>
>>> The commit id is different, because it is reverted and applied again. Yann?
>>
>> Commit 422c809 ("kconfig: fix randomising choice entries in presence of
>> KCONFIG_ALLCONFIG") reverts cleanly and reverting it fixes the bug. So
>> there is a plan B.
> 
> I do not understand how reverting 422c809 could have fixed the
> silentoldconfig issue: as I previously reported, it already happens on
> Linus' master.
> 
> I tried again jsut a few minutes ago against:
>     d7d7271: Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
> and it is already broken, although 422c809 is not yet in Linus' tree:
> 
>     $ make silentoldconfig </dev/null
>     scripts/kconfig/conf --silentoldconfig Kconfig
>     warning: (IA32_EMULATION) selects COMPAT_BINFMT_ELF which has unmet
>     direct dependencies (COMPAT && BINFMT_ELF)
>     *
>     * Restart config...
>     *
>     *
>     * Paravirtualized guest support
>     *
>     Paravirtualized guest support (PARAVIRT_GUEST) [N/y/?] (NEW) aborted!
> 
>     Console input/output is redirected. Run 'make oldconfig' to update configuration.
> 
>     make[1]: *** [silentoldconfig] Error 1
>     make: *** [silentoldconfig] Error 2
> 
> Or did I miss something?
> 
> However, oldconfig just works (with an error for each new symbol):
>     $ make oldconfig </dev/null
>     [--SNIP--]
>       NOP USB Transceiver Driver (NOP_USB_XCEIV) [N/m/?] (NEW)
>     Error in reading or end of file.
> 
>     #
>     # configuration written to .config
>     #

That (silent)oldconfig with stdin redirection throws an error if it
encounters a new option is expected and correct. The bug here is that
_normal_ oldconfig run apparently does not set all the options. I.e.

$ yes "" | make oldconfig; make silentoldconfig </dev/null

should always pass.

Michal
