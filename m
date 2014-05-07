Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbaEGI4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:56:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164AbaEGI4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:56:31 -0400
Message-ID: <5369F167.5000005@redhat.com>
Date: Wed, 07 May 2014 10:40:07 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] KVM: emulate: avoid per-byte copying in instruction
 fetches
References: <1399400175-23754-1-git-send-email-pbonzini@redhat.com>	<1399400175-23754-4-git-send-email-pbonzini@redhat.com> <jpgbnvai4ry.fsf@nelium.bos.redhat.com>
In-Reply-To: <jpgbnvai4ry.fsf@nelium.bos.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/05/2014 06:36, Bandan Das ha scritto:
>> > +	_x = *(_type __aligned(1) *) &_fc->data[ctxt->_eip - _fc->start]; \
> For my own understanding, how does the __aligned help here ?

Except for 16-byte SSE accesses, x86 doesn't distinguish aligned and 
unaligned accesses.  You can read 4 bytes at 0x2345 and the processor 
will do the right thing.  Still it's better to tell the compiler what 
we're doing.

> Wouldn't
> that result in unaligned accesses that will actually impact performance ?

These accesses *can* and will in fact be unaligned.  For example, say 
you have "mov ax,0x1234" which is 0xb8 0x34 0x12.  When you read it into 
the fetch cache, you will have data[0] == 0xb8, data[1] == 0x34, data[2] 
== 0x12.  Fetching the 16-bit immediate from data[1] will then be an 
unaligned access.

Paolo
