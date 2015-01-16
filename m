Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbbAPJnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 04:43:42 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:60845 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbbAPJnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 04:43:40 -0500
Message-ID: <54B8DD44.1020402@de.ibm.com>
Date: Fri, 16 Jan 2015 10:43:32 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/8] ppc/kvm: Replace ACCESS_ONCE with READ_ONCE
References: <1421312314-72330-1-git-send-email-borntraeger@de.ibm.com> <1421312314-72330-2-git-send-email-borntraeger@de.ibm.com> <1421363369.23332.8.camel@ellerman.id.au>
In-Reply-To: <1421363369.23332.8.camel@ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011609-0013-0000-0000-000002A1083D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.01.2015 um 00:09 schrieb Michael Ellerman:
> On Thu, 2015-01-15 at 09:58 +0100, Christian Borntraeger wrote:
>> ACCESS_ONCE does not work reliably on non-scalar types. For
>> example gcc 4.6 and 4.7 might remove the volatile tag for such
>> accesses during the SRA (scalar replacement of aggregates) step
>> (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)
>>
>> Change the ppc/kvm code to replace ACCESS_ONCE with READ_ONCE.
>>
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  arch/powerpc/kvm/book3s_hv_rm_xics.c |  8 ++++----
>>  arch/powerpc/kvm/book3s_xics.c       | 16 ++++++++--------
>>  2 files changed, 12 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/powerpc/kvm/book3s_hv_rm_xics.c b/arch/powerpc/kvm/book3s_hv_rm_xics.c
>> index 7b066f6..7c22997 100644
>> --- a/arch/powerpc/kvm/book3s_hv_rm_xics.c
>> +++ b/arch/powerpc/kvm/book3s_hv_rm_xics.c
>> @@ -152,7 +152,7 @@ static void icp_rm_down_cppr(struct kvmppc_xics *xics, struct kvmppc_icp *icp,
>>  	 * in virtual mode.
>>  	 */
>>  	do {
>> -		old_state = new_state = ACCESS_ONCE(icp->state);
>> +		old_state = new_state = READ_ONCE(icp->state);
> 
> These are all icp->state.
> 
> Which is a union, but it's only the size of unsigned long. So in practice there
> shouldn't be a bug here right?

This bug was that gcc lost the volatile tag when propagating aggregates to scalar types.
So in theory a union could be affected. See the original problem
 ( http://marc.info/?i=54611D86.4040306%40de.ibm.com ) 
which happened on 

union ipte_control {
        unsigned long val;
        struct {
                unsigned long k  : 1;
                unsigned long kh : 31;
                unsigned long kg : 32;
        };
};

Christian


