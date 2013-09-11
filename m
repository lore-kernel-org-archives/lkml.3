Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab3IKQdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:33:50 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:1515 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab3IKQdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:33:49 -0400
Message-ID: <52309B5F.70406@hp.com>
Date: Wed, 11 Sep 2013 12:33:35 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH 1/2] seqlock: Add a new blocking reader type
References: <1378909707-3347-1-git-send-email-Waiman.Long@hp.com> <20130911145536.GJ13318@ZenIV.linux.org.uk>
In-Reply-To: <20130911145536.GJ13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 10:55 AM, Al Viro wrote:
> On Wed, Sep 11, 2013 at 10:28:26AM -0400, Waiman Long wrote:
>> The sequence lock (seqlock) was originally designed for the cases
>> where the readers do not need to block the writers by making the
>> readers retry the read operation when the data change.
>>
>> Since then, the use cases have been expanded to include situations
>> where a thread does not need to change the data (effectively a reader)
>> at all but have to take the writer lock because it can't tolerate
>> changes to the protected structure. Some examples are the d_path()
>> function and the getcwd() syscall in fs/dcache.c where the functions
>> take the writer lock on rename_lock even though they don't need
>> to change anything in the protected data structure at all. This is
>> inefficient as a reader is now blocking other non-blocking readers
>> by pretending to be a writer.
>>
>> This patch tries to eliminate this inefficiency by introducing a new
>> type of blocking reader to the seqlock locking mechanism. This new
>> blocking reader will not block other non-blocking readers, but will
>> block other blocking readers and writers.
> Umm...  That's misleading - it doesn't _block_, it spins.  Moroever,
> seq_readbegin() also spins in presense of writer; the main property
> of this one is that it keeps writers away.

I used "block" in the sense that it will stop a writer from moving 
forward. I will update the commit log to make that more clear.
> Folks, any suggestions on better names?  The semantics we are getting is

I will welcome any better name suggestion and will incorporate that in 
the patch.

-Longman
