Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab3KYUGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:06:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232Ab3KYUGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:06:02 -0500
Date: Mon, 25 Nov 2013 21:05:53 +0100
From: Mateusz Guzik <mguzik@redhat.com>
To: Shawn Landden <shawnlandden@gmail.com>
Cc: Jason Baron <jbaron@akamai.com>, linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tom Herbert <therbert@google.com>
Subject: Re: disappearing listen()ed SO_REUSEPORT sockets across fork() when
 using epoll
Message-ID: <20131125200552.GA5826@mguzik.redhat.com>
References: <CAJusiZXq0CPHNvNCKCRp=XZ8UO9gFKVsU3cTEON5BCHDxrqFZQ@mail.gmail.com>
 <52939151.8030908@akamai.com>
 <CAJusiZWCrDovv_w29LeFA6m61CdWs4Ljxhwf_chNpNVGvmUKLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJusiZWCrDovv_w29LeFA6m61CdWs4Ljxhwf_chNpNVGvmUKLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 11:53:24AM -0800, Shawn Landden wrote:
> On Mon, Nov 25, 2013 at 10:05 AM, Jason Baron <jbaron@akamai.com> wrote:
> > On 11/22/2013 12:53 PM, Shawn Landden wrote:
> >> Hello, when running the attached program on 3.12 child processes
> >> are missing a socket fd opened, set with SO_REUSEPORT, listen()ed to,
> >> and added to epoll_ctl().
> >>
> >> This is the output I get when pointing "wget http://localhost:5555/"
> >> at the attached program:
> >>
> >> main PID 31591
> >> PID 31634 started
> >> PID 31634 accept()ed connection
> >> PID 31635 started
> >> PID 31636 started
> >> PID 31635 accept() failed: Bad file descriptor
> >> PID 31636 accept() failed: Bad file descriptor
> >> PID 31634 accept()ed connection
> >> PID 31634 accept()ed connection
> >> PID 31634 accept()ed connection
> >> PID 31634 accept()ed connection
> >>
> >>
> >> While I would expect something like:
> >>
> >> main PID 31591
> >> PID 31634 started
> >> PID 31634 accept()ed connection
> >> PID 31635 started
> >> PID 31636 started
> >> PID 31635 accept()ed connection
> >> PID 31636 accept()ed connection
> >>
> >> -more new processes, but inversely proportional to number of listening processes
> >> -accept() always returns successfully
> >>
> >>
> >
> > The 'close(sockfd);' looks to be racing with the accept() calls. Removing seems
> > to get the result you are looking for.
> Interesting. That works, but it shouldn't. The close() is operating in
> the parent, so it shouldn't affect the child,
> there is a leak here of process separation.
> 

You fork, then close sockfd in the parent. Thus, the very first child
can accept connectins just fine.

Subsequent forks give you children without sockfd, thus accept fails.
The first child continues to work just fine.

-- 
Thou shalt not follow the NULL pointer, for chaos and madness await thee
at its end. 
