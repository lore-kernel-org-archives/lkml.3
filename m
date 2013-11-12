Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3KLScA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:32:00 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:46196 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab3KLSb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:31:58 -0500
Date: Tue, 12 Nov 2013 10:31:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Does Itanium permit speculative stores?
Message-ID: <20131112183146.GN4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131111171307.GA27002@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31D5DB28@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D5DB28@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111218-0928-0000-0000-000003957965
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 06:00:26PM +0000, Luck, Tony wrote:
> > Does Itanium permit speculative stores?  For example, on Itanium what are
> > the permitted outcomes of the following litmus test, where both x and y
> > are initially zero?
> 
> We have a complier visible speculative read via the "ld.s" and "chk" instructions. But
> there is no speculative write ("st.s") instruction.  I think you are asking "can out of order
> writes become visible in this scenario?"
> 
> 	CPU 0				CPU 1
> 
> 	r1 = ACCESS_ONCE(x);		r2 = ACCESS_ONCE(y);
> 	if (r1)				if (r2)
> 		ACCESS_ONCE(y) = 1;		ACCESS_ONCE(x) = 1;
> 
> > In particular, is the outcome (r1 == 1 && r2 == 1) possible on Itanium
> > given this litmus test?
> 
> The "ACCESS_ONCE" macro casts to volatile - which will make gcc generate
> ordered "ld.acq" and "st.rel" instructions for your code snippets. So I think
> you should be fine.

Excellent!!!  Thank you for the information!

If I understand you correctly, this underscores the importance of
using ACCESS_ONCE() -- if you omit them in the above scenario, perhaps
you can see out-of-order stores becoming visible in this scenario?

Also, this resolves our earlier IRC discussion about Itanium's lack of
read-read cache coherence.  If you use ACCESS_ONCE properly, then on
Itanium the reads will become ld.acq instructions, ensuring the expected
cache coherence.

Very nice!

							Thanx, Paul

