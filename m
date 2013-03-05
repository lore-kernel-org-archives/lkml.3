Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3CEXYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:24:22 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51851 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab3CEXYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:24:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kay Sievers <kay@vrfy.org>
Cc: Kees Cook <keescook@google.com>, "Serge E. Hallyn" <serge@hallyn.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>, PaX Team <pageexec@freemail.hu>,
        linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Dave Jones <davej@redhat.com>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
	<20130303005700.GA32213@austin.hallyn.com>
	<874ngtxgt5.fsf@xmission.com>
	<CAGXu5j+bwUx6r++ttvYg4yJrUUHxoQ86tQ0JzEBoQQU6KAh9ww@mail.gmail.com>
	<874ngsrvrh.fsf@xmission.com>
	<CAGXu5jJiO=BmjVbpVJhxHbafn5T_SQbe5g-RLxRbmknNnQMyfQ@mail.gmail.com>
	<87k3pnmwpk.fsf_-_@xmission.com> <878v63mwm3.fsf_-_@xmission.com>
	<CAPXgP11AB7=2oeXtxb0so4a8hms7-_UWJDVE=6kndU062tGycQ@mail.gmail.com>
Date: Tue, 05 Mar 2013 15:24:11 -0800
In-Reply-To: <CAPXgP11AB7=2oeXtxb0so4a8hms7-_UWJDVE=6kndU062tGycQ@mail.gmail.com>
	(Kay Sievers's message of "Tue, 5 Mar 2013 20:06:45 +0100")
Message-ID: <87boax8m78.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/f88LF6zlyPzN8Wn0rgScSSg1Vjfl1vsk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay@vrfy.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] fs: Limit sys_mount to only request filesystem modules.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay@vrfy.org> writes:

> On Mon, Mar 4, 2013 at 8:51 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> Modify the request_module to prefix the file system type with "fs-"
>> and add aliases to all of the filesystems that can be built as modules
>> to match.
>>
>> A common practice is to build all of the kernel code and leave code
>> that is not commonly needed as modules, with the result that many
>> users are exposed to any bug anywhere in the kernel.
>>
>> Looking for filesystems with a fs- prefix limits the pool of possible
>> modules that can be loaded by mount to just filesystems trivially
>> making things safer with no real cost.
>
> '-' is a commonly used part of a module name, and does not mix well
> with ramdom user provided names.

The symbols '-' and '_' occur in 2382 out of 3968 modules from an
allmodconfig build, and modprobe ignores the difference between the two.
However only three of those modules begin with fs and none of them begin
with fs-.

Furthermore if it actually becomes a concern to ensure we are talking
about an alias rather than a real module name, the solution is to
change how we call modprobe.  As long as we are in the same namespace
something can go wrong.

fs- seems sufficiently unique for the purpose.

> We usually use ':' as the prefix separator for modaliases, when
> user-supplied strings are prefixed with the subsystem.

There are at least two different conventions in use.  For software
subsystems like the networking stack '-' is the commonly used
to separate the prefix.  For hardware specific subsystems ':' is
commonly used.  What I really don't want to load here are hardware
modules so using a hardware module style convention does not seem like
the right way to go.

> I think it would be nicer to change that, and I'm sure some creative
> guy calls the next filesystem of the month fs-$something :)

If it is a filesystem it simply does not matter.  The goal is to
only load filesystems.

If it is not a filesystem someone has choosen a confusing naming
convention.

If it turns out I am wrong it is a two line change.

Eric
