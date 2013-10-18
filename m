Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab3JRGqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 02:46:19 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:37371 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3JRGqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 02:46:17 -0400
Message-ID: <5260D932.8080007@redhat.com>
Date: Fri, 18 Oct 2013 08:46:10 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: linux-kernel@vger.kernel.org, gleb@redhat.com, agraf@suse.de,
        chao.zhou@intel.com, magnus@boden.cx, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: fix KVM_SET_XCRS loop
References: <1382021447-20216-1-git-send-email-pbonzini@redhat.com> <1382021447-20216-3-git-send-email-pbonzini@redhat.com> <20131018000421.GA6793@amt.cnet>
In-Reply-To: <20131018000421.GA6793@amt.cnet>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/10/2013 02:04, Marcelo Tosatti ha scritto:
> On Thu, Oct 17, 2013 at 04:50:47PM +0200, Paolo Bonzini wrote:
>> The loop was always using 0 as the index.  This means that
>> any rubbish after the first element of the array went undetected.
>> It seems reasonable to assume that no KVM userspace did that.
> 
> It is not a typo, look at __kvm_set_xcr when setting
> guest_xcrs->xcrs[i].value, with i != 0.

i is not the index of the XCR register, it's the index in the array.

The index is currently hardcoded to 0 when it is passed to
__kvm_set_xcr; but very reasonably __kvm_set_xcr returns 1 when index != 0.

IMO even the "if" in kvm_vcpu_ioctl_x86_set_xcrs is wrong: setting XCR
above XCR0 should fail KVM_SET_XCRS, while currently is ignored.  The
body of the loop should be simply:

	r = __kvm_set_xcr(vcpu, guest_xcrs->xcrs[i].xcr,
			  guest_xcrs->xcrs[i].value);
	if (r)
		break;

Paolo

> The code is not prepared to deal with XCR != 0 (because its not
> implemented in hw).
> 
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  arch/x86/kvm/x86.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index f4e1391..f91dff2 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3062,9 +3062,9 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
>>  
>>  	for (i = 0; i < guest_xcrs->nr_xcrs; i++)
>>  		/* Only support XCR0 currently */
>> -		if (guest_xcrs->xcrs[0].xcr == XCR_XFEATURE_ENABLED_MASK) {
>> +		if (guest_xcrs->xcrs[i].xcr == XCR_XFEATURE_ENABLED_MASK) {
>>  			r = __kvm_set_xcr(vcpu, XCR_XFEATURE_ENABLED_MASK,
>> -				guest_xcrs->xcrs[0].value);
>> +				guest_xcrs->xcrs[i].value);
>>  			break;
>>  		}
>>  	if (r)
>> -- 
>> 1.8.3.1

