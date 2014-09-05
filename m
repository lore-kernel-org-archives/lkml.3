Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbaIEA7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 20:59:43 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:49035 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751272AbaIEA7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 20:59:41 -0400
Message-ID: <54090AF4.7060406@hurleysoftware.com>
Date: Thu, 04 Sep 2014 20:59:32 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Laight <David.Laight@ACULAB.COM>
CC: Jakub Jelinek <jakub@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Miroslav Franc <mfranc@redhat.com>,
        Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org
Subject: Re: bit fields && data tearing
References: <20140712181328.GA8738@redhat.com>	 <54079B70.4050200@hurleysoftware.com> <1409785893.30640.118.camel@pasglop>	 <063D6719AE5E284EB5DD2968C1650D6D17487172@AcuExch.aculab.com> <1409824374.4246.62.camel@pasglop> <5408E458.3@zytor.com>
In-Reply-To: <5408E458.3@zytor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +cc linux-alpha ]

On 09/04/2014 06:14 PM, H. Peter Anvin wrote:
> On 09/04/2014 02:52 AM, Benjamin Herrenschmidt wrote:
>>
>> Yeah correct, alpha and bytes right ? Is there any other ? That's why I
>> suggested int.
>>
> 
> Even for Alpha it is only the 21064 AFAIK.

For -mcpu=ev5 (21164) and the following test

struct x {
	long a;
	char b;
	char c;
	char d;
	char e;
};

void store_b(struct x *p) {
	p->b = 1;
}

gcc generates:

void store_b(struct x *p) {
   0:	08 00 30 a0 	ldl	t0,8(a0)
   4:	01 f1 3f 44 	andnot	t0,0xff,t0
   8:	01 34 20 44 	or	t0,0x1,t0
   c:	08 00 30 b0 	stl	t0,8(a0)
  10:	01 80 fa 6b 	ret

IOW, rmw on 3 adjacent bytes, which is bad :)
For -mcpu=ev56 (21164A), the generated code is:

void store_b(struct x *p) {
   0:	01 00 3f 20 	lda	t0,1
   4:	08 00 30 38 	stb	t0,8(a0)
   8:	01 80 fa 6b 	ret

which is ok.
I have no idea how prevalent the ev56 is compared to the ev5.
Still we're talking about a chip that came out in 1996.

I still hate split caches though.

Regards,
Peter Hurley

