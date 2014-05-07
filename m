Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbaEGIeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:34:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbaEGIeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:34:44 -0400
Message-ID: <5369F020.2040706@redhat.com>
Date: Wed, 07 May 2014 10:34:40 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] KVM: emulate: avoid repeated calls to do_insn_fetch_bytes
References: <1399400175-23754-1-git-send-email-pbonzini@redhat.com>	<1399400175-23754-3-git-send-email-pbonzini@redhat.com> <jpgfvkmi5h6.fsf@nelium.bos.redhat.com>
In-Reply-To: <jpgfvkmi5h6.fsf@nelium.bos.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/05/2014 06:21, Bandan Das ha scritto:
>> > +		if (rc != X86EMUL_CONTINNUE)
>> > +			goto done;
>> > +	}
>> > +
>> >  	while (size--) {
>> > -		if (unlikely(ctxt->_eip == fc->end)) {
>> > -			rc = do_insn_fetch_bytes(ctxt);
>> > -			if (rc != X86EMUL_CONTINUE)
>> > -				return rc;
>> > -		}
>> >  		*dest++ = *src++;
>> >  		ctxt->_eip++;
>> >  		continue;
>> > @@ -4273,7 +4282,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
>> >  	if (insn_len > 0)
>> >  		memcpy(ctxt->fetch.data, insn, insn_len);
>> >  	else {
>> > -		rc = do_insn_fetch_bytes(ctxt);
>> > +		rc = do_insn_fetch_bytes(ctxt, 1);
> Is this saying that if the cache is full, then we fetch one more byte ?
>

No, it is saying that if the instruction is being executed for the first 
time (we can execute it multiple times if we reenter a repeated 
instruction after a userspace exit) we try to get at least one byte from 
RIP.  Most of the time, do_insn_fetch_bytes will fetch 15 bytes which 
are the maximum length of an instruction.

Passing op_size == 1 matches this change in do_insn_fetch_bytes:

-	if (unlikely(size == 0))
+	if (unlikely(size < op_size))

Paolo
