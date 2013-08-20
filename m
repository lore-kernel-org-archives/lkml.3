Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab3HTAp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 20:45:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1618 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162Ab3HTAp5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 20:45:57 -0400
From: Dan Williams <djbw@fb.com>
To: Jon Mason <jon.mason@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH 09/15] NTB: Use DMA Engine to Transmit and Receive
Thread-Topic: [PATCH 09/15] NTB: Use DMA Engine to Transmit and Receive
Thread-Index: AQHOj6bm/GJ0U1JbkEK1G/IDrnMk9JmdGJWAgAAx5ACAAH4dgP//lVuA
Date: Tue, 20 Aug 2013 00:45:54 +0000
Message-ID: <CE380608.2597D%djbw@fb.com>
In-Reply-To: <20130820000734.GD22169@jonmason-lab>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.6.130613
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <FC701EB07A7F4E41AD7F3DBD4000EA01@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-19_07:2013-08-19,2013-08-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 8/19/13 5:07 PM, "Jon Mason" <jon.mason@intel.com> wrote:

>> >> Is this for the case where we are bouncing back and forth between
>> >> sync/async?  Otherwise I do not see how transactions could get out of
>> >> order given you allocate a channel once per queue.  Is this comment
>> >> saying that the iowrite32 is somehow a fix, or is this comment a
>> >> FIXME?
>> >
>> >There is a case for a mix, the "copy_bytes" variable above switches to
>> >CPU for small transfers (which greatly increases throughput on small
>> >transfers).  The caveat to it is the need to flush the DMA engine to
>> >prevent out-of-order.  This comment is mainly an reminder of this
>>issue.
>> 
>> So this is going forward with the stall as a known issue?  The next
>>patch
>> should just do the sync to prevent the re-ordering, right?
>
>There is already a dma_sync_wait in the error path of ntb_async_rx to
>enforce the ordering.  Do I need to change the comment (or move it) to
>make it more obvious what is happening?

Yeah, I think it just needs to move to the dma_sync_wait() otherwise it
seems like it¹s an open issue that needs fixing.

>>>> > +       txd->callback = ntb_rx_copy_callback;
>> >> > +       txd->callback_param = entry;
>> >> > +
>> >> > +       cookie = dmaengine_submit(txd);
>> >> > +       if (dma_submit_error(cookie))
>> >> > +               goto err3;
>> >> > +
>> >> > +       qp->last_cookie = cookie;
>> >> > +
>> >> > +       dma_async_issue_pending(chan);
>> >> 
>> >> hmm... can this go in ntb_process_rx() so that the submission is
>> >> batched?  Cuts down on mmio.
>> >
>> >I moved it down to ntb_transport_rx (after the calls to
>> >ntb_process_rxc), and the performance seems to be roughly the same.
>> 
>> Yeah, not expecting it to be noticeable, but conceptually
>> 
>> submit
>> submit
>> submit
>> submit
>> issue
>> 
>> 
>> Is nicer than:
>> 
>> submit
>> issue
>> submit
>> issue
>> 
>> 
>
>I agree, but I liked having all the dma engine awareness
>compartmentalized in the ntb_async_* and callbacks.

Ok, makes sense.

--
Dan

