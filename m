Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbaGORhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:37:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54546 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932078AbaGORhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:37:17 -0400
Message-ID: <53C565B8.7000106@fb.com>
Date: Tue, 15 Jul 2014 13:32:40 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Martin Lau <kafai@fb.com>, <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ring-buffer: Fix polling on trace_pipe
References: <20140610060637.GA14045@devbig242.prn2.facebook.com>
In-Reply-To: <20140610060637.GA14045@devbig242.prn2.facebook.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-15_06:2014-07-15,2014-07-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.67438285458843e-11 kscore.compositescore=0
 circleOfTrustscore=22.4078557653337 compositescore=0.997695897463551
 urlsuspect_oldscore=0.997695897463551 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407150186
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/10/2014 02:06 AM, Martin Lau wrote:
> ring_buffer_poll_wait() should always put the poll_table to its wait_queue
> even there is immediate data available.  Otherwise, the following epoll and
> read sequence will eventually hang forever:
> 
> 1. Put some data to make the trace_pipe ring_buffer read ready first
> 2. epoll_ctl(efd, EPOLL_CTL_ADD, trace_pipe_fd, ee)
> 3. epoll_wait()
> 4. read(trace_pipe_fd) till EAGAIN
> 5. Add some more data to the trace_pipe ring_buffer
> 6. epoll_wait() -> this epoll_wait() will block forever
> 
> ~ During the epoll_ctl(efd, EPOLL_CTL_ADD,...) call in step 2,
>   ring_buffer_poll_wait() returns immediately without adding poll_table,
>   which has poll_table->_qproc pointing to ep_poll_callback(), to its
>   wait_queue.
> ~ During the epoll_wait() call in step 3 and step 6,
>   ring_buffer_poll_wait() cannot add ep_poll_callback() to its wait_queue
>   because the poll_table->_qproc is NULL and it is how epoll works.
> ~ When there is new data available in step 6, ring_buffer does not know
>   it has to call ep_poll_callback() because it is not in its wait queue.
>   Hence, block forever.
> 
> Other poll implementation seems to call poll_wait() unconditionally as the very
> first thing to do.  For example, tcp_poll() in tcp.c.

Reviewed-by: Chris Mason <clm@fb.com>

This looked horribly wrong to me at first, but Martin walked me through
how the polling code is setting up waiters.  We have it in production here.
