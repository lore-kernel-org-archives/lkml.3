Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab3IISrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:47:11 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:42902 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab3IISrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:47:09 -0400
Message-ID: <522E17A1.1020205@hp.com>
Date: Mon, 09 Sep 2013 14:46:57 -0400
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
References: <1378743493-33546-1-git-send-email-Waiman.Long@hp.com> <1378743493-33546-2-git-send-email-Waiman.Long@hp.com> <20130909172905.GN13318@ZenIV.linux.org.uk> <CA+55aFx_pUwHg35Ueb4Ewy8ZrBA_UtFbQqdRzL64_Q7iQ=V-rA@mail.gmail.com> <20130909180604.GO13318@ZenIV.linux.org.uk> <20130909182111.GQ13318@ZenIV.linux.org.uk> <20130909183608.GR13318@ZenIV.linux.org.uk>
In-Reply-To: <20130909183608.GR13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 02:36 PM, Al Viro wrote:
> On Mon, Sep 09, 2013 at 07:21:11PM +0100, Al Viro wrote:
>> Actually, it's better for prepend_path() as well, because it's actually
>>
>> 	rcu_read_lock();
>> 	seq = read_seqbegin(&rename_lock);
>> again:
>> 	....
>> 	if (error)
>> 		goto done;
>> 	....
>> 	if (!seqretry_and_lock(&rename_lock, seq))
>> 		goto again;	/* now as writer */
>> done:
>> 	seqretry_done(&rename_lock, seq);
>> 	rcu_read_unlock();
>>
>> Posted variant will sometimes hit the following path:
>> 	* seq_readlock()
>> 	* start generating the output
>> 	* hit an error
>> [another process has taken and released rename_lock for some reason]
>> 	* hit read_seqretry_and_unlock(), which returns 1.
>> 	* retry everything with seq_writelock(), despite the error.
>>
>> It's not too horrible (we won't be looping indefinitely, ignoring error
>> all along), but it's certainly subtle enough...
> FWIW, what I propose is this (just the d_path-related parts):
>
>

I am fine with your proposed change as long as it gets the job done. It 
doesn't really matter if you do it or I do it.

Thank for taking the effort to make it better for us all.

-Longman
