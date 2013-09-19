Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3ISK4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:56:34 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:34541 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3ISK4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:56:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, kay@vrfy.org, linux-kernel@vger.kernel.org
References: <1379538938-5032-1-git-send-email-tj@kernel.org>
Date: Thu, 19 Sep 2013 05:48:52 -0500
In-Reply-To: <1379538938-5032-1-git-send-email-tj@kernel.org> (Tejun Heo's
	message of "Wed, 18 Sep 2013 17:15:34 -0400")
Message-ID: <87pps5dr3f.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX197FePL3yMGr0vjHzh9HLYAe665ODRySLM=
X-SA-Exim-Connect-IP: 98.172.60.222
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0424]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCHSET] sysfs: implement sysfs_remove()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> Currently, there are multiple variants of internal sysfs removal
> functions and the directory removal behavior is a bit weird in that
> while it does remove the files contained immediately in the directory
> it wouldn't recurse into its subdirectories, even the group ones which
> belong to the same kobject.

There are two very big problems with this direction.
1) It violates the principle of least surprise.  In particular it messes
   up the mental model of people like Al Viro.  Which can easily lead to
   code breaking during routine maintenance because of unexpecte
   semantics.

2) Recursive removal is not safe.  There are very weird and somewhat
   pathological cases where sysfs directories are removed out of order
   aka parent before sibling, and (if my memory holds) recursive removal
   takes this from a little bit ugly to actually breaking things.

For long term maintenance and simplicity I believe we will be in much
better shape if we take directory removal in the opposite direction, and
fix the small number of issues with the users and don't support any kind
of recursive removal.

Eric
