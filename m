Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762144Ab3IDHmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:42:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55546 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab3IDHmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:42:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jan Kaluza <jkaluza@redhat.com>
Cc: davem@davemloft.net, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, eparis@redhat.com, rgb@redhat.com,
        tj@kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        viro@zeniv.linux.org.uk
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>
	<1378275261-4553-1-git-send-email-jkaluza@redhat.com>
Date: Wed, 04 Sep 2013 00:42:26 -0700
In-Reply-To: <1378275261-4553-1-git-send-email-jkaluza@redhat.com> (Jan
	Kaluza's message of "Wed, 4 Sep 2013 08:14:18 +0200")
Message-ID: <878uzdf2xp.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX182oms2+74UezCBRJRzdbBxaIMtTI0zNns=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4997]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jan Kaluza <jkaluza@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 0/3] Send audit/procinfo/cgroup data in socket-level control message
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kaluza <jkaluza@redhat.com> writes:

> Hi,
>
> this patchset against net-next (applies also to linux-next) adds 3 new types
> of "Socket"-level control message (SCM_AUDIT, SCM_PROCINFO and SCM_CGROUP).
>
> Server-like processes in many cases need credentials and other
> metadata of the peer, to decide if the calling process is allowed to
> request a specific action, or the server just wants to log away this
> type of information for auditing tasks.
>
> The current practice to retrieve such process metadata is to look that
> information up in procfs with the $PID received over SCM_CREDENTIALS.
> This is sufficient for long-running tasks, but introduces a race which
> cannot be worked around for short-living processes; the calling
> process and all the information in /proc/$PID/ is gone before the
> receiver of the socket message can look it up.

> Changes introduced in this patchset can also increase performance
> of such server-like processes, because current way of opening and
> parsing /proc/$PID/* files is much more expensive than receiving these
> metadata using SCM.

Can I just say ick, blech, barf, gag.

You don't require this information to be passed.  You are asking people
to suport a lot of new code for the forseeable future.  The only advantage
appears to be for short lived racy processes that don't even bother to
make certain their message was acknowleged before exiting.

You sent this during the merge window which is the time for code
integration and testing not new code.

By my count you have overflowed cb in struct sk_buff and are stomping on
_skb_refdest.

If you are going to go crazy and pass things is there a reason you do
not add a patch to pass the bsd SCM_CREDS?  That information seems more
relevant in a security context and for making security decisions than
about half the information you are passing.

Eric
