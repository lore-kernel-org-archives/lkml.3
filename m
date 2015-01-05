Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbbAEV5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:57:12 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8695 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011AbbAEV5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:57:09 -0500
Message-ID: <54AB08AB.7040009@sonymobile.com>
Date: Mon, 5 Jan 2015 13:56:59 -0800
From: Tim Bird <tim.bird@sonymobile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, "mmarek@suse.cz" <mmarek@suse.cz>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "tranmanphong@gmail.com" <tranmanphong@gmail.com>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "cov@codeaurora.org" <cov@codeaurora.org>,
        "dh.herrmann@gmail.com" <dh.herrmann@gmail.com>,
        "hughd@google.com" <hughd@google.com>,
        "bobby.prani@gmail.com" <bobby.prani@gmail.com>,
        "serge.hallyn@ubuntu.com" <serge.hallyn@ubuntu.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "koct9i@gmail.com" <koct9i@gmail.com>
CC: "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: WIP alternative - was Re: [PATCH v3 14/20] selftests/size: add
 install target to enable test install
References: <cover.1419387513.git.shuahkh@osg.samsung.com> <c961f80614b02a2f3c6455518d1f6fabdaf6c7f3.1419387513.git.shuahkh@osg.samsung.com> <54A4B174.2010501@sonymobile.com> <54AB0215.5020409@osg.samsung.com>
In-Reply-To: <54AB0215.5020409@osg.samsung.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 01:28 PM, Shuah Khan wrote:
> On 12/31/2014 07:31 PM, Tim Bird wrote:
...
>> The install phase is desperately needed for usage of kselftest in
>> cross-target situations (applicable to almost all embedded).  So this
>> is great stuff.
> 
> Thanks.
> 
>>
>> I worked a bit on isolating the install stuff to a makefile include file.
>> This allows simplifying some of the sub-level Makefiles a bit, and allowing
>> control of some of the install and run logic in less places.
>>
>> This is still a work in progress, but before I got too far along, I wanted
>> to post it for people to provide feedback.  A couple of problems cropped
>> up that are worth discussing, IMHO.
>>
>> 1) I think it should be a requirement that each test has a single
>> "main" program to execute to run the tests.  If multiple tests are supported
>> or more flexibility is desired for additional arguments, or that sort of
>> thing, then that's fine, but the automated script builder should be able
>> to run just a single program or script to have things work.  This also
>> makes things more consistent.  In the case of the firmware test, I created
>> a single fw_both.sh script to do this, instead of having two separate
>> blocks in the kselftest.sh script.
> 
> It is a good goal for individual tests to use a main program to run
> tests, even though, I would not make it a requirement. I would like to
> leave that decision up to the individual test writer.
>
OK.  It helps to have a single line when trying to isolate
RUN_TEST creation into the include file, but there may be other
ways to accomplish this.

>>
>> 2) I've added a CROSS_INSTALL variable, which can call an arbitrary program
>> to place files on the target system (rather than just calling 'install').
>> In my case, I'd use my own 'ttc cp' command, which I can extend as necessary
>> to put things on a remote machine.  This works for a single directory,
>> but things get dicier with sub-directory trees full of files (like
>> the ftrace test uses.)
>>
>> If additional items need to be installed to the target, then maybe a setup
>> program should be used, rather than just copying files.
>>
>> 3) Some of the scripts were using /bin/bash to execute them, rather
>> than rely on the interpreter line in the script itself (and having
>> the script have executable privileges).  Is there a reason for this?
>> I modified a few scripts to be executable, and got rid of the
>> explicit execution with /bin/bash.
> 
> Probably no reason other than the choice made by the test writer.
> It could be cleaned up and made consistent, however, I would see
> this as a separate enhancement type work that could be done on its
> own and not include it in the install work.

OK - this was also something that simplified the creation
of the RUN_TEST variable in the isolated include file.
Also, having the interpreter explicit in the invocation line
in the Makefile as well as in the script itself is a bit redundant.
>>
>> The following is just a start...  Let me know if this direction looks
>> OK, and I'll finish this up.  The main item to look at is
>> kselftest.include file.  Note that these patches are based on Shuah's
>> series - but if you want to use these ideas I can rebase them onto
>> mainline, and break them out per test sub-level like Shuah did.
> 
> One of the reasons I picked install target approach is to enable the
> feature by extending the existing run_tests support. This way we will
> have the feature available quickly. Once that is supported, we can work
> on evolving to a generic approach to use the include file approach, as
> the changes you are proposing are based on the the series I sent out,
> and makes improvements to it.
> 
> kselftest.include file approach could work for several tests and tests
> that can't use the generic could add their own install support.
> 
> I propose evolving to a generic kselftest.include as the second step in
> evolving the install feature. Can I count on you do the work and update
> the tests to use kselftest.include, CROSS_INSTALL variable support?

Yes.  I'd be happy to evolve it through phases to support the include
file and cross-target install feature.

Is there anything I can help with in the mean time?  Some of the tests
require a directory tree of files rather than just a few top-level files
(e.g. ftrace).

I was thinking about doing some work to tar-ify the needed directories of
data files during build, and untar it in the execution area during the
install step.  Do you want me to propose something there?
 -- Tim

