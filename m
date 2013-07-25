Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab3GYLBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 07:01:48 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:53044 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab3GYLBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 07:01:45 -0400
Message-ID: <1374750101.23313.16.camel@edumazet-glaptop>
Subject: Re: [PATCH 1/1] TX throttling bug-fixing patch of AX88179_178A
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Oliver Neukum <oliver@neukum.org>,
        Grant Grundler <grundler@google.com>, Freddy Xin <freddy@asix.com.tw>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ASIX Louis =?UTF-8?Q?=5B=E8=98=87=E5=A8=81=E9=99=B8=5D?= 
	<louis@asix.com.tw>,
        Allan Chou <allan@asix.com.tw>
Date: Thu, 25 Jul 2013 04:01:41 -0700
In-Reply-To: <CACVXFVNyFk0Zpi4tC0ENiq8RcrtrjYW-Dhs+A56+Pw4BKm8y8A@mail.gmail.com>
References: <1374311809-4155-1-git-send-email-freddy@asix.com.tw>
	 <1374512879.4990.19.camel@edumazet-glaptop>
	 <CANEJEGvPc56ePP=_bxfA4PZfsM3vw=MsRjbWwrFBC3eP-GtzZg@mail.gmail.com>
	 <1374518312.1635.29.camel@bwh-desktop.uk.level5networks.com>
	 <1374518841.4990.26.camel@edumazet-glaptop>
	 <1374522471.1635.48.camel@bwh-desktop.uk.level5networks.com>
	 <1374559827.4990.143.camel@edumazet-glaptop>
	 <CACVXFVN0eN9E9efr8UdqFz68-emHa2o-RQ0RYfazEq8f=qxkLQ@mail.gmail.com>
	 <1374729058.23313.8.camel@edumazet-glaptop>
	 <CACVXFVNyFk0Zpi4tC0ENiq8RcrtrjYW-Dhs+A56+Pw4BKm8y8A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 13:25 +0800, Ming Lei wrote:
> On Thu, Jul 25, 2013 at 1:10 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > On Thu, 2013-07-25 at 10:28 +0800, Ming Lei wrote:
> >
> >>
> >> It depends if size of sg buffer(except for last one) in the sg list can be
> >> divided by usb endpoint's max packet size(512 or 1024), at least there
> >> is the constraint:
> >>
> >> http://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/commit/?h=usb-next&id=10e232c597ac757e7f8600649f7e872e86de190f
> >>
> >> I am wondering if network stack can meet that.  If not, it might be a
> >> bit difficult
> >> because lots of USB host controller don't support that, and driver may have
> >> to support SG and non-SG at the same time for working well on all HCs.
> >
> > I do not see the problem.
> >
> > If one skb has 2 fragments of 32KB, couldn't they be split into 64 1K
> > segments by the device driver ?
> 
> OK, if length of fragments of all SKBs from network stack can always guarantee
> to be divided by 1024, that is fine,  seems I worry about too much, :-)

Unfortunately, there is no such guarantee. TSO permits sendfile() zero
copy operation, so the frags can be of any size, any offset...

In this mode, the first element (skb->head) will typically contains the
headers, and there are way below 512 bytes.

So even with lowering netdev->gso_max_size under PAGE_SIZE, most of the
packets will need to be copied into a single segment.



