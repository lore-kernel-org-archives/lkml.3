Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaCHD46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 22:56:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbaCHD44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 22:56:56 -0500
Message-ID: <1394251012.17193.9.camel@localhost>
Subject: Re: [RFC][PATCH] audit: Simplify by assuming the callers socket
 buffer is large enough
From: Eric Paris <eparis@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: ebiederm@xmission.com, sgrubb@redhat.com, rgb@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, akpm@linux-foundation.org
Date: Fri, 07 Mar 2014 22:56:52 -0500
In-Reply-To: <20140307.194801.1893514114998807038.davem@davemloft.net>
References: <7457128.6VP2v68V93@x2> <87wqg8zfj4.fsf@xmission.com>
	 <1394232722.17779.57.camel@flatline.rdu.redhat.com>
	 <20140307.194801.1893514114998807038.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 19:48 -0500, David Miller wrote:
> From: Eric Paris <eparis@redhat.com>
> Date: Fri, 07 Mar 2014 17:52:02 -0500
> 
> > Audit is non-tolerant to failure and loss.
> 
> Netlink is not a loss-less transport.
I'm happy to accept that (and know it to be true).  How can I better
architect things?  It seems Eric is complaining that when we get a
request for info, we queue that info up, and then use a kthread to make
it available when the task next calls recv.  By using blocking sockets
in the kthread we have no problem with the size of the socket read buf.
If we switch to non-blocking sockets how can we possibly queue up more
than rmem size of data?  (honestly, if userspace used INT_MAX it is
almost certainly overkill for even the largest rulesets, but
theoretically, it's not...)

Is our design somehow wrong?  Flawed?  Mind you it's pretty dumb that we
do basically the same thing in 3 different audit code path, but the
architecture doesn't seem crazy to me.  Then again, I'm not brilliant by
any stretch!

   +------------------------------------------------------------------+
   |                                                                  |
   |               auditctl (audit tool run by root)                  |
   |         netlink send                         netlink receive     |
   +------------------------------------------------------------------+
                  +                                        ^
                  |                                        |
                  v                                        +
      +----------------------------+        +------------------------+
      | kernel audit generate skbs |        | send skbs to userspace |
      +----------------------------+        +------------------------+
                  +                                        ^
                  |        +------------------------+      |
                  +------->| send skbs to a kthread |+-----+
                           +------------------------+

