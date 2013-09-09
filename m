Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab3IIW5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 18:57:44 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:31023 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab3IIW5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 18:57:42 -0400
Message-ID: <522E5259.7090000@hp.com>
Date: Mon, 09 Sep 2013 18:57:29 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
References: <1378743493-33546-1-git-send-email-Waiman.Long@hp.com> <1378743493-33546-2-git-send-email-Waiman.Long@hp.com> <20130909172905.GN13318@ZenIV.linux.org.uk> <CA+55aFx_pUwHg35Ueb4Ewy8ZrBA_UtFbQqdRzL64_Q7iQ=V-rA@mail.gmail.com> <20130909180604.GO13318@ZenIV.linux.org.uk> <20130909182111.GQ13318@ZenIV.linux.org.uk> <20130909183608.GR13318@ZenIV.linux.org.uk> <522E17A1.1020205@hp.com> <20130909191028.GT13318@ZenIV.linux.org.uk> <20130909192835.GU13318@ZenIV.linux.org.uk>
In-Reply-To: <20130909192835.GU13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 03:28 PM, Al Viro wrote:
> On Mon, Sep 09, 2013 at 08:10:29PM +0100, Al Viro wrote:
>> On Mon, Sep 09, 2013 at 02:46:57PM -0400, Waiman Long wrote:
>>
>>> I am fine with your proposed change as long as it gets the job done.
>> I suspect that the real problem is the unlock part of read_seqretry_or_unlock();
>> for d_walk() we want to be able to check if we need retry and continue walking
>> if we do not.  Let's do it that way: I've applied your patch as is, with the
>> next step being
>> 	* split read_seqretry_or_unlock():
>> need_seqretry() (return (!(seq&  1)&&  read_seqretry(lock, seq))
>> done_seqretry() (if (seq&  1) write_sequnlock(lock, seq)),
>> your if (read_seqretry_or_unlock(&rename_lock,&seq))
>> 		goto restart;
>> becoming
>> 	if (need_seqretry(&rename_lock, seq)) {
>> 		seq = 1;
>> 		goto restart;
>> 	}
>> 	done_seqretry(&rename_lock, seq);
>>
>> Then d_walk() is trivially massaged to use of read_seqbegin_or_lock(),
>> need_seqretry() and done_seqretry().  Give me a few, I'll post it...
> OK, how about this?  It splits read_seqretry_or_unlock(), takes
> rcu_read_{lock,unlock} in the callers and converts d_walk() to those
> primitives.  I've pushed that and your commit into vfs.git#experimental
> (head at 48f5ec2, should propagate in a few); guys, please give it a look
> and comment.

The changes look good to me. I was planning to take rcu_read_lock() out 
and doing something similar, but your change is good. BTW, I think Linus 
want to add some comments on why RCU lock is needed without the 
rename_lock, but I can put that in with a follow-up patch once the 
current change is merged.

Thank for your help and inspiration on this patch.

-Longman
