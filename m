Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580Ab3BID0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 22:26:50 -0500
Received: from chrocht.moloch.sk ([62.176.169.44]:48949 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141Ab3BID0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 22:26:49 -0500
Message-ID: <5115C1F7.8000705@250bpm.com>
Date: Sat, 09 Feb 2013 04:26:47 +0100
From: Martin Sustrik <sustrik@250bpm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: Eric Wong <normalperson@yhbt.net>
CC: Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] eventfd: implementation of EFD_MASK flag
References: <1360219292-19754-1-git-send-email-sustrik@250bpm.com> <5113FCA7.4020207@mit.edu> <51140A60.4070705@250bpm.com> <CALCETrXEy5hLh6i7nTGH607gnc=kd0S+of9i0-nt828MGwbQZQ@mail.gmail.com> <20130208220817.GA4256@dcvr.yhbt.net>
In-Reply-To: <20130208220817.GA4256@dcvr.yhbt.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/13 23:08, Eric Wong wrote:

>>>>> poll(2) function (POLLIN, POLLOUT, POLLERR, POLLHUP etc.) Specified
>>>>> events will
>>>>> be signaled when polling (select, poll, epoll) on the eventfd is done
>>>>> later on.
>>>>> 'ptr' is an opaque pointer that is not interpreted by eventfd object.
>>>>
>>>> How does this interact with EPOLLET?
>>>
>>> That's an interesting question. The original eventfd code doesn't do
>>> anything specific to either edge or level mode. Neither does my patch.
>>>
>>> Inspection of the code seems to suggest that edge vs. level distinction is
>>> handled elsewhere (ep_send_events_proc) where there is a separate list of
>>> ready events and the function, after returning the event, decides whether to
>>> leave the event in the list (level) or delete it from the list (edge).
>
> Right, the edge vs. level distinction is internal to epoll.

I wrote a test program for EFD_MASK+EPOLLET and it seems to behave in 
intuitive kind of way:

int main ()
{
     int fd;
     struct efd_mask mask;
     ssize_t nbytes;
     int rc;
     int ep;
     struct epoll_event epe;

     fd = eventfd (0, EFD_MASK);

     ep = epoll_create (10);
     assert (ep != -1);
     epe.events = EPOLLIN | EPOLLET;
     rc = epoll_ctl (ep, EPOLL_CTL_ADD, fd, &epe);
     assert (rc != -1);

     mask.events = 0;
     nbytes = write (fd, &mask, sizeof (mask));
     assert (nbytes == sizeof (mask));
     rc = epoll_wait (ep, &epe, 1, 100);
     assert (rc == 0);

     mask.events = POLLIN;
     nbytes = write (fd, &mask, sizeof (mask));
     assert (nbytes == sizeof (mask));
     rc = epoll_wait (ep, &epe, 1, 100);
     assert (rc == 1 && epe.events == EPOLLIN);
     rc = epoll_wait (ep, &epe, 1, 100);
     assert (rc == 0);

     mask.events = POLLIN;
     nbytes = write (fd, &mask, sizeof (mask));
     mask.events = 0;
     nbytes = write (fd, &mask, sizeof (mask));
     rc = epoll_wait (ep, &epe, 1, 100);
     assert (rc == 0);

     rc = close (ep);
     assert (rc == 0);
     rc = close (fd);
     assert (rc == 0);

     return 0;
}

Martin
