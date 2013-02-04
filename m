Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3BDPjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:39:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38676 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab3BDPjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:39:11 -0500
Date: Mon, 4 Feb 2013 15:39:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: H?vard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: avr32: add dummy syscalls
Message-ID: <20130204153902.GC4503@ZenIV.linux.org.uk>
References: <20130127195714.GA11224@samfundet.no>
 <20130127203009.GG4503@ZenIV.linux.org.uk>
 <20130127203954.GA22063@samfundet.no>
 <20130204001055.GV4503@ZenIV.linux.org.uk>
 <20130204003047.GW4503@ZenIV.linux.org.uk>
 <20130204013111.GX4503@ZenIV.linux.org.uk>
 <20130204030221.GY4503@ZenIV.linux.org.uk>
 <CACiLriQbrKvo128hhH4Cd3U+qZwgXPGFEAs4b3=SsK59=4Kkkw@mail.gmail.com>
 <20130204050550.GA4503@ZenIV.linux.org.uk>
 <CACiLriSguKWSfFfFGK99q1h+GLrfCSyh55xW8o67kOao3g5sWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACiLriSguKWSfFfFGK99q1h+GLrfCSyh55xW8o67kOao3g5sWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 09:35:39PM -0800, H?vard Skinnemoen wrote:

> Right.
> 
> > But yes, 32bit/32bit/64bit/32bit is another interesting case -
> > fanotify_mark is 32/32/64/32/32.  From what ABI says it would seem to
> > be r12/r11/r8:r9/r10/stack, but if I understand you correctly, we'll
> > end up wanting *two* arguments on stack...
> 
> Yes, I think there may be a difference between the IAR and gcc ABI
> here. But I could be wrong.

Umm...  avr32_function_arg() in atmel 4.4.3 patch:
  if (arg_rsize == 8)
    {
      /* use r11:r10 or r9:r8. */
      if (!(GET_USED_INDEX (cum, 1) || GET_USED_INDEX (cum, 2)))
       index = 1;
      else if ((last_reg_index == 4) &&
               !(GET_USED_INDEX (cum, 3) || GET_USED_INDEX (cum, 4)))
       index = 3;
      else
       index = -1;
    }
  else if (arg_rsize == 4)
    {                          /* Use first available register */
      index = 0;
      while (index <= last_reg_index && GET_USED_INDEX (cum, index))
       index++;
      if (index > last_reg_index)
       index = -1;
    }

So it will use the gap in case of 32/32/64/32; the first two calls will
take index 0 and 1 (r12 and r11 resp.), the third will take 3 and 4
(r9:r8) and the fourth will take 2 (r10).  Relevant part of
avr32_function_arg_advance():
  /* Mark the used registers as "used". */
  if (GET_REG_INDEX (cum) >= 0)
    {
      SET_USED_INDEX (cum, GET_REG_INDEX (cum));
      if (arg_rsize == 8)
       {
         SET_USED_INDEX (cum, (GET_REG_INDEX (cum) + 1));
       }
    }
i.e. the third argument will only stomp on 3 and 4, leaving 2 unused.

And as far as I can see, their 4.3.3 patch does the same thing...
