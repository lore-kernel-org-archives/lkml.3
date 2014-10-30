Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbaJ3EWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 00:22:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58593 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaJ3EWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 00:22:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>, simon.mcvittie@collabora.co.uk,
        daniel@zonque.org, alban.crequy@collabora.co.uk,
        javier.martinez@collabora.co.uk, Tom Gundersen <teg@jklm.no>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	<CALCETrWrxc8foPYbRPtxwNX0sHK_=vLFLDXXyXu+2U2=B+=qCQ@mail.gmail.com>
	<20141029222729.GB8129@kroah.com>
	<CALCETrVxvF2ie=vVgpjeqikn+nci_9jyKfU4s3t=4cjyNZNaNQ@mail.gmail.com>
Date: Wed, 29 Oct 2014 21:20:23 -0700
In-Reply-To: <CALCETrVxvF2ie=vVgpjeqikn+nci_9jyKfU4s3t=4cjyNZNaNQ@mail.gmail.com>
	(Andy Lutomirski's message of "Wed, 29 Oct 2014 19:27:54 -0700")
Message-ID: <87bnourxx4.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/J+UjF7+fPMW1tcxFAjpiWzFeQctAiQfI=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 4060 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 4.6 (0.1%), b_tie_ro: 3.4 (0.1%), parse: 1.47 (0.0%),
	extract_message_metadata: 20 (0.5%), get_uri_detail_list: 3.6 (0.1%),
	tests_pri_-1000: 7 (0.2%), tests_pri_-950: 1.19 (0.0%), tests_pri_-900: 1.02
	(0.0%), tests_pri_-400: 33 (0.8%), check_bayes: 32 (0.8%), b_tokenize: 10
	(0.2%), b_tok_get_all: 12 (0.3%), b_comp_prob: 4.4 (0.1%), b_tok_touch_all:
	2.9 (0.1%), b_finish: 0.92 (0.0%), tests_pri_0: 419 (10.3%), tests_pri_500:
	3570 (87.9%), poll_dns_idle: 3561 (87.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 00/12] Add kdbus implementation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The userspace API breaks userspace in an unfixable way.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Problem the first.
- Using global names for containers makes it impossible to create
  unprivileged containers.

  This is a back to the drawing board problem, and makes device
  nodes fundamentally unsuited to what you are doing.

  There is no way that I can see to make it safe for an unprivileged
  user to create arbitrary named busses.  Especially in the presence
  of allowing unprivileged checkpoint/restart.

  This is particularly bad as kdbus explicitly allows unprivielged
  creation of new kdbus instances.

  This problem is a userspace regression.

Problem the second.
- The security checks in the code are not based on who opens the
  file descriptors but instead based on who is used the file
  descriptors at any give moment.

  That pattern has been shown to be exploitable.

  I expect the policy database makes this poor choice of permission
  checks even worse.  Pass a more privileged user a kdbus file
  descriptor and all of sudden things that were not possible on
  that file descriptor become possible.

Problem the third.
- You are using device numbers for things created by unprivileged
  users.  That breaks checkpoint/restart.  Aka CRIU.

  We can not migrate a container to a new machine and preserve the
  device numbers.  

  We can not migrate a container to a new machine and have any hope
  of preserving the container patsh under /dev/kdbus/...

  Both of which look like fundamental show stoppers for
  checkpoint/restart.

Andy Lutomirski <luto@amacapital.net> writes:

> On Wed, Oct 29, 2014 at 3:27 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Wed, Oct 29, 2014 at 03:15:51PM -0700, Andy Lutomirski wrote:
>>> (reply 1/2 -- I'm replying twice to keep the threading sane)
>>>
>>> On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> wrote:
>>> > kdbus is a kernel-level IPC implementation that aims for resemblance to
>>> > the the protocol layer with the existing userspace D-Bus daemon while
>>> > enabling some features that couldn't be implemented before in userspace.
>>> >
>>>
>>> >  * Support for multiple domains, completely separated from each other,
>>> >    allowing multiple virtualized instances to be used at the same time.
>>>
>>> Given that there is no such thing as a device namespace, how does this work?
>>
>> See the document for the details.
>
> They seem insufficient to me, so I tried to dig in to the code.  My
> understanding is:
>
> The parent container has /dev mounted.  It sends an IOCTL (which
> requires global capabilities).  In response, kdbus creates a whole
> bunch of devices that get put (by udev or devtmpfs, I presume) in a
> subdirectory.  Then the parent container mounts that subdirectory in
> the new container.
>
> This is IMO rather problematic.
>
> First, it enforces the existence of a kdbus domain hierarchy where
> none should be needed.
>
> Second, it's incompatible with nested user namespaces.  The middle
> namespace can't issue the ioctl.
>
> Third, it requires a devtmpfs submount in the child container.  This
> scares me, especially since there are no device namespaces.  Also, the
> child container appears to be dependent on the host udev to arbitrate
> everything, which seems totally wrong to me.  (Also, now we're exposed
> to attacks where the child container creates busses or endpoints or
> whatever with malicious names to try to trick the host into screwing
> up.)
>
> ISTM this should be solved either with device namespaces (which is
> well known to be a giant can of worms) or by abandoning the concept of
> kdbus using device nodes entirely.
>
> What if kdbus were kdbusfs?  If you want to use it in a container, you
> mount a brand-new kdbusfs there.  No weird domain hierarchy, no global
> privilege, no need to name containers, obvious migration semantics, no
> dependence on udev/devtmpfs at all, etc.
>
> Eric, any thoughts here?

I think a kdbusfs modeled on devpts with newinstance at
mount time would solve the naming problems.

That would break one of the current kdbus use cases that allows an
unprivileged user to create a bus.

Eric

p.s.  Please excuse my brevity I have am in the middle of packing up my
possessions (including my main machine), as I move this week.


