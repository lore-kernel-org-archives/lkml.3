Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaJOPTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:19:07 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:54455 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaJOPTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:19:04 -0400
Message-ID: <543E9060.8060300@landley.net>
Date: Wed, 15 Oct 2014 10:18:56 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: Josh Triplett <josh@joshtriplett.org>, frowand.list@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v5] init: Disable defaults if init= fails
References: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net>	<542B4DA3.5080105@gmail.com>	<542B519B.6010001@landley.net>	<542B5E44.40303@gmail.com>	<542B7200.6030902@landley.net>	<CALCETrWr--A26UEv_7DeZa-Te1fTBDQgCdZt24n5LWkAnOa6jQ@mail.gmail.com>	<20141001180510.GA28540@cloud>	<CALCETrUK07j8+iQ8oSW70sgePxg_GJY3ASBBS+U9fvp_f2Rz5w@mail.gmail.com> <20141014140052.2f114c158ffe6cd953020f1c@linux-foundation.org>
In-Reply-To: <20141014140052.2f114c158ffe6cd953020f1c@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/14 16:00, Andrew Morton wrote:
> On Wed, 1 Oct 2014 11:13:14 -0700 Andy Lutomirski <luto@amacapital.net> wrote:
> 
>> On Wed, Oct 1, 2014 at 11:05 AM,  <josh@joshtriplett.org> wrote:
>>> On Tue, Sep 30, 2014 at 09:53:56PM -0700, Andy Lutomirski wrote:
>>>> I significantly prefer default N.  Scripts that play with init= really
>>>> don't want the fallback, and I can imagine contexts in which it could
>>>> be a security problem.
>>>
>>> While I certainly would prefer the non-fallback behavior for init as
>>> well, standard kernel practice has typically been to use "default y" for
>>> previously built-in features that become configurable.  And I'd
>>> certainly prefer a compile-time configuration option like this (even
>>> with default y) over a "strictinit" kernel command-line option.
>>>
>>
>> Fair enough.
>>
>> So: "default y" for a release or two, then switch the default?  Having
>> default y will annoy virtme, though it's not the end of the world.
>> Virtme is intended to work with more-or-less-normal kernels.
>>
> 
> Adding another Kconfig option is tiresome.  What was wrong with strictinit=?

Adding kernel command line options isn't tiresome? A quick grep of
kernel-parameters.txt ballparks us at around 600 of them so far, and the
one you're proposing one would would translate to "and I really mean it".

Chopping out legacy code with an ifconfig is a step to deprecating it
and eventually removing it. Adding code to do less is bloat that will
stay there forever.

The old behavior is surprising, most people putting together systems in
the past 10 years probably aren't aware it does that unless they got bit
by it. You can't specify a series of fallback inits from the command
line, only the magic hardcoded values can provide a random mix of places
to look for "init" (including in /etc/init for some reason? Has that
_ever_ been a thing?) and then calling a different program entirely
("sh") at a hardwired absolute path because reasons.

Initramfs does not do this fallback nonsense, it has one place it looks
("/init") and rdinit= changes that without magic fallbacks to the old
one if it's not found. If you specify rdinit= it won't even look for
"/init":

        if (!ramdisk_execute_command)
                ramdisk_execute_command = "/init";

        if (sys_access((const char __user *) ramdisk_execute_command, 0)
!= 0) {
                ramdisk_execute_command = NULL;
                prepare_namespace();
        }


(I.E. if it finds the one and only rdinit command name in ramfs, it
doesn't overmount it with the root= contents. Once overmounted, any
other init programs in ramfs wouldn't matter.)

The current behavior is inconsistent and crazy, and only there for
legacy reasons. We _already_ don't do it for newer codepaths. That's why
chopping it out with kconfig (and immediately deprecating the config
option) makes more sense than adding extra code to not do it.

Rob
