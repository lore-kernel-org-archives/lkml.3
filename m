Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaCAEfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 23:35:22 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53009 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaCAEfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 23:35:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <8738j3vzry.fsf@xmission.com>
	<20140301011142.GK16640@madcap2.tricolour.ca>
Date: Fri, 28 Feb 2014 20:34:52 -0800
In-Reply-To: <20140301011142.GK16640@madcap2.tricolour.ca> (Richard Guy
	Briggs's message of "Fri, 28 Feb 2014 20:11:42 -0500")
Message-ID: <87fvn2r0yb.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19QGcL/ahjmDszEOlX33r2xvgV+NQY41pc=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1412]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Richard Guy Briggs <rgb@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] audit: Use struct net not pid_t to remember the network namespce to reply in
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> writes:

> On 14/02/28, Eric W. Biederman wrote:
>> While reading through 3.14-rc1 I found a pretty siginficant mishandling
>> of network namespaces in the recent audit changes.
>> 
>> In struct audit_netlink_list and audit_reply add a reference to the
>> network namespace of the caller and remove the userspace pid of the
>> caller.  This cleanly remembers the callers network namespace, and
>> removes a huge class of races and nasty failure modes that can occur
>> when attempting to relook up the callers network namespace from a pid_t
>> (including the caller's network namespace changing, pid wraparound, and
>> the pid simply not being present).
>
> Ok, so I see that avoiding pid_t in struct audit_reply and struct
> audit_netlink_list is necessary.  Why not switch to struct pid?
>
> How does this patch solve a caller's network namespace changing?

This solves the callers network namespace changing or the caller going
away entirely (a much more serious concern) because we capture the
network namespace at the time of the request when the caller is in the
kernel.  I would have simply captured the socket we want to reply on but
there did not appear to be a good way to do that.

Reading through it again capturing current->nsproxy->net_ns is striclty
wrong.  We should be capturing sock_net(NETLINK_CB(skb).sk).  The
network namespace of the requesting socket.  That handles even weird
cases of passing file descriptors between processes in different network
namespaces.  (An incremental patch to change to code to selct the
network namespace of the requesting socket to follow in a moment).

Still what my patch implements today at least means we won't oops the
kernel if the audit process exits early, and causes get_net_ns_by_pid
to return NULL.


This whole code path is so crazy because what we really should be doing
is sending the packets in nonblocking mode and just dropping packets
if the receiving socket does not have enough socket buvffers.

Eric
