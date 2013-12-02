Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab3LBLmC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 06:42:02 -0500
Received: from smtp.citrix.com ([66.165.176.89]:3833 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab3LBLl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:41:59 -0500
X-IronPort-AV: E=Sophos;i="4.93,810,1378857600"; 
   d="scan'208";a="79663487"
Message-ID: <529C7205.3060406@citrix.com>
Date: Mon, 2 Dec 2013 11:41:57 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <Ian.Campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <JBeulich@suse.com>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH 4/4] xen/xenbus: Avoid synchronous wait on
 XenBus stalling shutdown/restart.
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com> <1383932286-25080-5-git-send-email-konrad.wilk@oracle.com> <528E485C.5030906@citrix.com> <20131126165016.GH2959@phenom.dumpdata.com>
In-Reply-To: <20131126165016.GH2959@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/13 16:50, Konrad Rzeszutek Wilk wrote:
> On Thu, Nov 21, 2013 at 05:52:28PM +0000, David Vrabel wrote:
>> On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
>>> The 'read_reply' works with 'process_msg' to read of a reply in XenBus.
>>> 'process_msg' is running from within the 'xenbus' thread. Whenever
>>> a message shows up in XenBus it is put on a xs_state.reply_list list
>>> and 'read_reply' picks it up.
>>>
>>> The problem is if the backend domain or the xenstored process is killed.
>>> In which case 'xenbus' is still awaiting - and 'read_reply' if called -
>>> stuck forever waiting for the reply_list to have some contents.
>>>
>>> This is normally not a problem - as the backend domain can come back
>>> or the xenstored process can be restarted. However if the domain
>>> is in process of being powered off/restarted/halted - there is no
>>> point of waiting on it coming back - as we are effectively being
>>> terminated and should not impede the progress.
>>>
>>> This patch solves this problem by checking the 'system_state' value
>>> to see if we are in heading towards death. We also make the wait
>>> mechanism a bit more asynchronous.
>>
>> This seems to be checking the wrong thing conceptually.  We should abort
>> the wait if xenstored is dead not if our domain is dying.
>>
>> I think you can consider xenstored as dead if:
>>
>> a) it's local and we're dying.
> 
> OK. Not sure exactly how to do that but that should be possible.

xen_store_domain_type == XS_LOCAL and looking at system_state?

>> b) it's remote and the remote domain is dead.
> 
> OK, any idea how to do that? As in check if a remote domain is dead?

Let someone who cares about xenstore domains fix this -- this is not the
most common use case.

I'd be happy to have some thing like:

bool xenbus_ok(void)
{
    switch (xen_store_domain_type) {
    case XS_LOCAL:
         return system_state != dying;
    case XS_PV:
    case XS_HVM;
         /* FIXME: could check remote domain is alive, but it's
            normally dom0. */
         return true;
    // ...
    default:
         return true;
    }
}

>>> Fixes-Bug: http://bugs.xenproject.org/xen/bug/8
>>
>> This bug link has no useful information in it.

And it now does, thanks Ian.

>>> --- a/drivers/xen/xenbus/xenbus_xs.c
>>> +++ b/drivers/xen/xenbus/xenbus_xs.c
>>> @@ -148,9 +148,24 @@ static void *read_reply(enum xsd_sockmsg_type *type, unsigned int *len)
>>>  
>>>  	while (list_empty(&xs_state.reply_list)) {
>>>  		spin_unlock(&xs_state.reply_lock);
>>> -		/* XXX FIXME: Avoid synchronous wait for response here. */
>>> -		wait_event(xs_state.reply_waitq,
>>> -			   !list_empty(&xs_state.reply_list));
>>> +		wait_event_timeout(xs_state.reply_waitq,
>>> +				   !list_empty(&xs_state.reply_list),
>>> +				   msecs_to_jiffies(500));
>>
>> This is still a synchronous wait.  Is the removal of the FIXME comment
>> correct?
> 
> I thought that the comment was meant in terms of it blocking forever.
> But perhaps that was not the intent of the comment?

Ok. I don't anticipate a fully async interface here being sensible anyway.

David
