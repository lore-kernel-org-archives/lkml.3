Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaBMLhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:37:22 -0500
Received: from canardo.mork.no ([148.122.252.1]:58625 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbaBMLhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:37:20 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Emil Goode <emilgoode@gmail.com>
Cc: Steve Glendinning <steve.glendinning@shawell.net>,
        Oliver Neukum <oneukum@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Freddy Xin <freddy@asix.com.tw>, Eric Dumazet <edumazet@google.com>,
        Ming Lei <ming.lei@canonical.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Liu Junliang <liujunliang_ljl@163.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbnet: remove generic hard_header_len check
Organization: m
References: <1392249836-27151-1-git-send-email-emilgoode@gmail.com>
	<87fvnn4c2k.fsf@nemi.mork.no> <20140213112016.GA4245@lianli>
Date: Thu, 13 Feb 2014 12:36:30 +0100
In-Reply-To: <20140213112016.GA4245@lianli> (Emil Goode's message of "Thu, 13
	Feb 2014 12:20:16 +0100")
Message-ID: <87y51f2qip.fsf@nemi.mork.no>
User-Agent: Gnus/5.130009 (Ma Gnus v0.9) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emil Goode <emilgoode@gmail.com> writes:

> Yes I should have put a comment in the changelog about this. All skbs that
> are passed to rx_process have their state set to rx_cleanup and just because
> the skb was cloned doesn't mean that we should free the original in a
> different way. As it is I think we are acctually missing a call to
> usb_free_urb that is called on the common rx_cleanup path.

Yes, I wondered about that as well, thinking that this part actually
should be a separate patch for net+stable.

But then I wondered how we could possibly have had a bug like that
living here for so long, and the answer is we haven't.  You don't want
to free the URB.  It is already resubmitted with a different skb as its
buffer.  The call to usb_free_urb in the rx_cleanup path is there only
for the cases where the URB is not resubmitted. The rx_complete callback
is controlling this by updating entry->urb as appropriate.  So it will
always be NULL if rx_process is called, and the call to usb_free_urb has
no effect.

Rearranging this code to always take the same cleanup path is still a
very nice cleanup IMHO.


Bjørn
