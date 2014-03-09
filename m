Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaCIAB4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 19:01:56 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55178 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaCIABy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 19:01:54 -0500
Date: Sat, 08 Mar 2014 19:01:52 -0500 (EST)
Message-Id: <20140308.190152.901247434238422514.davem@davemloft.net>
To: saproj@gmail.com
Cc: behanw@converseincode.com, linville@tuxdriver.com,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu, dl9pf@gmx.de,
        viniciustinti@gmail.com, charlebm@gmail.com
Subject: Re: [PATCH v2] mac80211: LLVMLinux: Remove VLAIS usage from
 mac80211
From: David Miller <davem@davemloft.net>
In-Reply-To: <CABikg9y_j-SDOsMj1C5uogP0HNj6bsB_ySVFtAh_oNgZ0swd=g@mail.gmail.com>
References: <1394177091.4653.1.camel@jlt4.sipsolutions.net>
	<1394241960-1764-1-git-send-email-behanw@converseincode.com>
	<CABikg9y_j-SDOsMj1C5uogP0HNj6bsB_ySVFtAh_oNgZ0swd=g@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 08 Mar 2014 16:01:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Antonov <saproj@gmail.com>
Date: Sat, 8 Mar 2014 21:29:57 +0100

> On 8 March 2014 02:26,  <behanw@converseincode.com> wrote:
>> diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
>> index 7c7df47..3317578 100644
>> --- a/net/mac80211/aes_ccm.c
>> +++ b/net/mac80211/aes_ccm.c
>> @@ -23,12 +23,14 @@ void ieee80211_aes_ccm_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
>>                                u8 *data, size_t data_len, u8 *mic)
>>  {
>>         struct scatterlist assoc, pt, ct[2];
>> -       struct {
>> -               struct aead_request     req;
>> -               u8                      priv[crypto_aead_reqsize(tfm)];
>> -       } aead_req;
>>
>> -       memset(&aead_req, 0, sizeof(aead_req));
>> +       char aead_req_data[sizeof(struct aead_request) +
>> +                               crypto_aead_reqsize(tfm) +
>> +                               CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
>> +
>> +       struct aead_request *aead_req = (void *) aead_req_data;
> 
> Bad trick with regards to alignment.
> The alignment requirement for struct aead_request is stronger than
> what an array of chars may have.

Indeed, this will crash on platforms such as sparc64 that trap on
unaligned accesses.

You have to tell the compiler the alignment using proper types.
