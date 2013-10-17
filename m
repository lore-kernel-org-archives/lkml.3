Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762218Ab3JQSNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:13:37 -0400
Received: from smtprelay0124.hostedemail.com ([216.40.44.124]:58391 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759087Ab3JQSNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:13:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1978:2196:2199:2393:2553:2559:2562:2740:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3873:4043:4250:4321:4385:4605:5007:7550:7652:10004:10400:10450:10455:10848:11026:11232:11473:11658:11914:12043:12294:12438:12517:12519:12740:13069:13311:13357:19904:19999,0,RBL:none,CacheIP:none,Bayesian:
X-HE-Tag: pie43_591aa355c275a
X-Filterd-Recvd-Size: 3019
Message-ID: <1382033611.22110.131.camel@joe-AO722>
Subject: Re: [PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
From: Joe Perches <joe@perches.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Chen Gong <gong.chen@linux.intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        m.chehab@samsung.com, arozansk@redhat.com,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Date: Thu, 17 Oct 2013 11:13:31 -0700
In-Reply-To: <CA+8MBbLDVJgY9WWTY6vPeY7+L04-xDPofJ9eLwh7dJipBBh51w@mail.gmail.com>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
	 <1381935366-11731-4-git-send-email-gong.chen@linux.intel.com>
	 <1381978749.22110.76.camel@joe-AO722>
	 <20131017063059.GB14946@gchen.bj.intel.com>
	 <1381993136.22110.95.camel@joe-AO722>
	 <20131017073824.GC14946@gchen.bj.intel.com>
	 <1381998750.22110.101.camel@joe-AO722> <20131017084014.GD5036@pd.tnic>
	 <1382000112.22110.103.camel@joe-AO722>
	 <CA+8MBbLDVJgY9WWTY6vPeY7+L04-xDPofJ9eLwh7dJipBBh51w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-17 at 09:10 -0700, Tony Luck wrote:
> On Thu, Oct 17, 2013 at 1:55 AM, Joe Perches <joe@perches.com> wrote:
> > It's cost free to add the BUILD_BUG_ON
> > and perhaps you underestimate the runtime
> > bug checking effort,
> 
> This looks OK to me.  Gong: This doesn't stop people from using variables
> as arguments ... they just won't get a check for (h) < (l).

Another possibility is to swap high and low if necessary and
maybe warn when either is negative or too large for the bit width.

#define GENMASK(h, l)							\
({									\
	size_t high = h;						\
	size_t low = l;							\
	BUILD_BUG_ON(__builtin_constant_p(l) &&				\
		     __builtin_constant_p(h) &&				\
		     (l) > (h));					\
	BUILD_BUG_ON(__builtin_constant_p(l) &&				\
		     __builtin_constant_p(h) &&				\
		     ((l) >= BITS_PER_LONG ||				\
		      (h) >= BITS_PER_LONG));				\
	WARN_ONCE((!__builtin_constant_p(l) &&				\
		   ((l) < 0 || (l) > BITS_PER_LONG)) ||			\
		  (!__builtin_constant_p(h) &&				\
		   ((h) < 0 || (h) > BITS_PER_LONG)) ||			\
		  (l) > (h),						\
		  "GENMASK: invalid mask values: l: %u, h: %d\n",	\
		  (l), (h));						\
	if (low > high)							\
		swap(low, high);					\
	(((U32_C(1) << (high - low + 1)) - 1) << low);			\
})

And maybe this should be renamed something like
#define BIT_MASK_RANGE(h, l)
or
#define BIT_MASK_SHIFTED(h, l)


