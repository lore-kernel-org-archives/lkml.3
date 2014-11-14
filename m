Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965118AbaKNOIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:08:12 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:53191 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934535AbaKNOIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:08:09 -0500
Message-ID: <54660C93.6050801@st.com>
Date: Fri, 14 Nov 2014 15:07:15 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Cc: <linux@rasmusvillemoes.dk>, <gong.chen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, <tytso@mit.edu>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <kernel@stlinux.com>, <eric.paire@st.com>
Subject: Re: [PATCH v4] bitops: Fix shift overflow in GENMASK macros
References: <1415267659-10563-1-git-send-email-maxime.coquelin@st.com> <20141113140936.e2e45a8970b5bb4195fd5065@linux-foundation.org>
In-Reply-To: <20141113140936.e2e45a8970b5bb4195fd5065@linux-foundation.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-14_06:2014-11-14,2014-11-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/13/2014 11:09 PM, Andrew Morton wrote:
> On Thu,  6 Nov 2014 10:54:19 +0100 Maxime COQUELIN <maxime.coquelin@st.com> wrote:
>
>> On some 32 bits architectures, including x86, GENMASK(31, 0) returns 0
>> instead of the expected ~0UL.
>>
>> This is the same on some 64 bits architectures with GENMASK_ULL(63, 0).
>>
>> This is due to an overflow in the shift operand, 1 << 32 for GENMASK,
>> 1 << 64 for GENMASK_ULL.
>>
>> Fixes: 10ef6b0dffe404bcc54e94cb2ca1a5b18445a66b
>> Cc: <stable@vger.kernel.org> #v3.13+
>> Reported-by: Eric Paire <eric.paire@st.com>
>> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> Why cc:stable?  Does this bug cause some observed kernel misbehaviour?
> If so, please fully describe that in the changelog.  This will help
> people to determine whether this patch might fix a bug they're
> observing, and will help them to decide whether they should backport
> this patch into their kernels.
We encountered some misbehavior on not upstreamed code.

Looking at all GENMASK and GENMASK_ULL occurences in v3.18-rc4,
I (only) found one possible candidate in drivers/spi/spi_xtensa-xtfpga.c:

static u32 xtfpga_spi_txrx_word(struct spi_device *spi, unsigned nsecs,
                 u32 v, u8 bits)
{
     struct xtfpga_spi *xspi = spi_master_get_devdata(spi->master);

     xspi->data = (xspi->data << bits) | (v & GENMASK(bits - 1, 0));
...
}

Max F., can xtfpga_spi_txrx_word() be called with "bits" = 32?
If yes, then GENMASK(bits - 1, 0) result would be unpredictable on some 
architectures.
I don't know if Xtensa architecture is impacted though.

But even if Xtensa SPI driver is not impacted,
maybe future fixes that will be integrated into stable releases will use 
GENMASK(),
and so could possibly be impacted by the bug.

Andrew, with this information, do you think we should take this patch in 
stable branches?

>
> I'm assuming that Peter will be merging this patch.

Yes, Peter already added this patch in his tree.
>
Kind regards,
Maxime
