Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaK0JB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:01:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152AbaK0JBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:01:25 -0500
Date: Thu, 27 Nov 2014 09:09:01 +0008
From: Jason Wang <jasowang@redhat.com>
Subject: RE: [PATCH v2] hv: hv_fcopy: drop the obsolete message on transfer
 failure
To: Dexuan Cui <decui@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        KY Srinivasan <kys@microsoft.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Message-Id: <1417078861.18179.2@smtp.corp.redhat.com>
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C613E641D8@HKNPRD3002MB017.064d.mgd.msft.net
	>
References: <1417073491-19388-1-git-send-email-decui@microsoft.com>
	<1245181972.17067189.1417072471636.JavaMail.zimbra@redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E641D8@HKNPRD3002MB017.064d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, Nov 27, 2014 at 4:50 PM, Dexuan Cui <decui@microsoft.com> wrote:
>>  -----Original Message-----
>>  From: Jason Wang [mailto:jasowang@redhat.com]
>>  Sent: Thursday, November 27, 2014 15:15 PM
>>  To: Dexuan Cui
>>  Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; 
>> driverdev-
>>  devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com; KY
>>  Srinivasan; vkuznets@redhat.com; Haiyang Zhang
>>  Subject: Re: [PATCH v2] hv: hv_fcopy: drop the obsolete message on 
>> transfer
>>  failure
>>  ----- Original Message -----
>>  > In the case the user-space daemon crashes, hangs or is killed, we
>>  > need to down the semaphore, otherwise, after the daemon starts 
>> next
>>  > time, the obsolete data in fcopy_transaction.message or
>>  > fcopy_transaction.fcopy_msg will be used immediately.
>>  >
>>  > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>  > Cc: K. Y. Srinivasan <kys@microsoft.com>
>>  > Signed-off-by: Dexuan Cui <decui@microsoft.com>
>>  > ---
>>  >
>>  > v2: I removed the "FCP" prefix as Greg asked.
>>  >
>>  >     I also updated the output message a little:
>>  >     "FCP: failed to acquire the semaphore" -->
>>  >     "can not acquire the semaphore: it is benign"
>>  >
>>  >  drivers/hv/hv_fcopy.c | 9 +++++++++
>>  >  1 file changed, 9 insertions(+)
>>  >
>>  > diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
>>  > index 23b2ce2..c518ad9 100644
>>  > --- a/drivers/hv/hv_fcopy.c
>>  > +++ b/drivers/hv/hv_fcopy.c
>>  > @@ -86,6 +86,15 @@ static void fcopy_work_func(struct work_struct
>>  *dummy)
>>  >  	 * process the pending transaction.
>>  >  	 */
>>  >  	fcopy_respond_to_host(HV_E_FAIL);
>>  > +
>>  > +	/* In the case the user-space daemon crashes, hangs or is 
>> killed, we
>>  > +	 * need to down the semaphore, otherwise, after the daemon 
>> starts
>>  next
>>  > +	 * time, the obsolete data in fcopy_transaction.message or
>>  > +	 * fcopy_transaction.fcopy_msg will be used immediately.
>>  > +	 */
>>  
>>  Looks still racy, what happens if the daemon start before 
>> down_trylock()
>>  but after fcopy_respont_to_host() here?
> Jason,
> Thanks for pointing this out!
> IMO we can resolve this by adding down_trylock() in fcopy_release().
> What's your opinion?


Looks better and need to cancel the timeout also here?
> 
> 
>>  
>>  > +	if (down_trylock(&fcopy_transaction.read_sema))
>>  > +		pr_debug("can not acquire the semaphore: it is benign\n");
>>  
>>  typo
>>  > +
>>  >  }
> Sorry -- what typo do you mean?

s/benign/begin/ ?
> 
> Thanks,
> -- Dexuan
> �NrybXǧv^)޺{.n+{zXܨ}Ơz&j:+vzZ++zfh~izw?&)ߢf^jǫym@Aa0hi

