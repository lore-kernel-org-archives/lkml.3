Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab3FFH1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:27:08 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28414 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab3FFH0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:26:54 -0400
Message-ID: <51B03A51.9060602@oracle.com>
Date: Thu, 06 Jun 2013 15:29:21 +0800
From: vaughan <vaughan.cao@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: dgilbert@interlog.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sg: atomize check and set sdp->exclude in sg_open
References: <51AF0269.9070900@oracle.com> <20130605132746.GA1690@logfs.org> <51AF646D.7030903@oracle.com> <20130605154106.GA2737@logfs.org> <51B037FE.2020402@oracle.com>
In-Reply-To: <51B037FE.2020402@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年06月06日 15:19, vaughan 写道:
> 于 2013年06月05日 23:41, Jörn Engel 写道:
>> On Thu, 6 June 2013 00:16:45 +0800, vaughan wrote:
>>> 于 2013年06月05日 21:27, Jörn Engel 写道:
>>>> On Wed, 5 June 2013 17:18:33 +0800, vaughan wrote:
>>>>>
>>>>> Check and set sdp->exclude should be atomic when set in sg_open().
>>>>
>>>> The patch is line-wrapped.  More importantly, it doesn't seem to do
>>> It's shorter than the original line, so I just leave it like this...
>>
>> Sure.  What I meant by line-wrapped is that your mailer mangled the
>> patch.  Those two lines should have been one:
>>>>> -                       ((!sfds_list_empty(sdp) || get_exclude(sdp))
>>>>> ? 0 : set_exclude(sdp, 1)));
>>
>>>> what your description indicates it should do.  And lastly, does this
>>>> fix a bug, possibly even one you have a testcase for, or was it found
>>>> by code inspection?
>>> I found it by code inspection. A race condition may happen with the
>>> old code if two threads are both trying to open the same sg with
>>> O_EXCL simultaneously. It's possible that they both find fsds list
>>> is empty and get_exclude(sdp) returns 0, then they both call
>>> set_exclude() and break out from wait_event_interruptible and resume
>>> open. So it's necessary to check again with sg_open_exclusive_lock
>>> held to ensure only one can set sdp->exclude and return >0 to break
>>> out from wait_event loop.
>>
>> Makes sense.  And reading the code again, I have to wonder what monkey
>> came up with the get_exclude/set_exclude functions.
>>
>> Can I sucker you into a slightly larger cleanup?  I think the entire
>> "get_exclude(sdp)) ? 0 : set_exclude(sdp, 1)" should be simplified.
>> And once you add the try_set_exclude(), set_exclude will only ever do
>> clear_exclude, so you might as well rename and simplify that as well.
> I find my patch is not enough to avoid this race condition said above.
> Since sg_add_sfp() just do an add_to_list without check and wait_event
> check don't set a sign to announce a future add_to_list is on going, the
> time window between wait_event and sg_add_sfp gives others to open sg
> before the prechecked sg_add_sfp() called.
>
> The same case also happens when one shared and one exclude open occur
> simultaneously. If the shared open pass the precheck stage and ready to
> sg_add_sfp(). At this time another exclude open will also pass the check:
>    ((!sfds_list_empty(sdp) || get_exclude(sdp)) ? 0 :
> try_set_exclude(sdp)));
> Then, both open can succeed.
>
> I think the point is we separate the check&add routine and haven't set
> an sign to let others wait until the whole actions complete. I suppose
> we may change the steps a bit to avoid trouble like this. If we can
> malloc&initialize sfp at first, and then check&add sfp under the
> protection of sg_index_lock, everything seems to be quite simple.
We also should prevent sg_device change those parameters which are 
needed to copy to sfp during sfp initialization.

Regards,
Vaughan

>
>
> Regards,
> Vaughan
>
>>
>> Let no good deed go unpunished.
>>
>> Jörn
>>
>> --
>> It's just what we asked for, but not what we want!
>> -- anonymous
>>
