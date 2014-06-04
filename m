Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaFDScq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:32:46 -0400
Received: from ns.horizon.com ([71.41.210.147]:34779 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750780AbaFDScp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:32:45 -0400
Date: 4 Jun 2014 14:32:44 -0400
Message-ID: <20140604183244.30105.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dborkman@redhat.com, linux@horizon.com
Subject: Re: [PATCH 1/3] lib: crc32: Greatly shrink CRC combining code
Cc: akpm@linux-foundation.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <538F1535.3080500@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the nitpicks!

> I think you might want to cc Andrew Morton <akpm@linux-foundation.org>
> to let this go via akpm's tree for misc changes, perhaps?

I don't care, but akpm is fine by me.  I'll send out a v2 after I resolve
one minor point with you; see below.

Once that's done, may I add a Reviewed-by: or Acked-by: line from you?

> Looks good to me! Do you have any performance numbers to share?

Actually, I didn't bother benchmarking it because the improvement was
so obvious, but here's a quick test showing a 35.5x performance gain.

     Old       New      Delta
  0: 83005684  2314192 (-80691492)
  1: 82730196  2313836 (-80416360)
  2: 82805636  2312736 (-80492900)
  3: 82648160  2344304 (-80303856)
  4: 82531928  2314940 (-80216988)
  5: 82669440  2312976 (-80356464)
  6: 82528792  2313984 (-80214808)
  7: 82415116  2313796 (-80101320)
  8: 82451620  2314000 (-80137620)
  9: 82811052  2329708 (-80481344)
 10: 82903344  2311120 (-80592224)
 11: 82549032  2313540 (-80235492)
 12: 82564660  2330260 (-80234400)
 13: 82289788  2312972 (-79976816)
 14: 82535828  2312036 (-80223792)
 15: 82664040  2313284 (-80350756)
 16: 82629476  2309744 (-80319732)
 17: 82806812  2329628 (-80477184)
 18: 82379284  2312876 (-80066408)
 19: 82483400  2313004 (-80170396)
 20: 82651232  2314244 (-80336988)
 21: 82327508  2330456 (-79997052)
 22: 82641324  2330664 (-80310660)
 23: 82538192  2314024 (-80224168)
MIN: 82289788  2309744 (-79980044)

Here's the test loop.  Although it's subject to compiler rearrangements,
I tried to charge the loop overhead to the new code.

static void
do_test(uint64_t times[2])
{
	uint32_t crc0 = 1, crc1 = 1;
	uint64_t t0, t1, sum0 = 0, sum1 = 0;
	int i;

	t1 = t0 = rdtsc();
	for (i = 1024; i < 2048; i++) {
		sum0 += t1;
		crc0 = crc32_generic_shift(crc0, i, CRC32C_POLY_LE);
		sum1 += rdtsc();
		crc1 = crc32_generic_combine(crc1, 0, i, CRC32C_POLY_LE);
		t1 = rdtsc();
	}
	times[0] = sum0 + t1 - sum1 - t0;	// Old code
	times[1] = sum1 - sum0;			// New code
	if (crc0 != crc1)
		printf("Mismatch!  %08x != %08x\n", crc0, crc1);
}

It's possible to do a bit better with more effort (exploiting
the precomputed CRC tables for modular reduction) but this fruit
was hanging *so* low I couldn't resist grabbing it.

>> -extern u32  crc32_le_combine(u32 crc1, u32 crc2, size_t len2);
>> +u32  crc32_le_shift(u32 crc, size_t len) __attribute_const__;

> Perhaps a newline here.

Question: where do you think a newline should go?  It's not obvious
to me.  My style has been to keep as much of a declaration on one line
as possible so "git grep <function> include" is as informative as possible.

>> -extern u32  __crc32c_le_combine(u32 crc1, u32 crc2, size_t len2);
>> +u32  __crc32c_le_shift(u32 crc, size_t len) __attribute_const__;

> Ditto. Or, put both *_shift() helper signatures before the crc32_le_combine
> kdoc comment.

Um, same basic question.  I agree that putting a declaration
between the kdoc and the function is strange, but that doesn't
seem to be what you're commenting in...

Now that I've gotten an ack, I'm happy to be more aggressive about
tweaking comments.  I just wanted to focus the diff on the code changes.

>> +/**
>> + * crc32_generic_shift - Append len 0 bytes to crc, in logarithmic time
>> + * @crc: The original little-endian CRC (i.e. lsbit is x^31 coefficient)
>> + * @len: The number of bytes.  @crc is multiplied by x^(8*@len)
>> + # @polynomial: The modulus used to reduce the result to 32 bits.

>      ^^ seems this should have been a '*'

Yes, obviously.  Thanks for catching that.

>> +static u32 __attribute_const__ crc32_generic_shift(u32 crc, size_t len,
>> +				 u32 polynomial)

> u32 polynomial is not correctly aligned to the opening '(' from the previous line.

Thanks again.
