Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaJBNDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:03:55 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55801 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaJBNDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:03:52 -0400
Message-ID: <1412255026.15991.32.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [Linux-ima-devel] [PATCH v2 3/4] ima: check appraisal flag in
 the ima_file_free() hook
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 02 Oct 2014 09:03:46 -0400
In-Reply-To: <542D3A28.5000603@polito.it>
References: <cover.1412188590.git.d.kasatkin@samsung.com>
	 <600aeb6a5b8eca7eb381392e142ca71484717e9c.1412188590.git.d.kasatkin@samsung.com>
	 <542D0C33.2010700@polito.it> <542D1B4B.7040904@samsung.com>
	 <542D2398.8000300@polito.it> <542D2C56.9040505@samsung.com>
	 <542D3A28.5000603@polito.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100213-1344-0000-0000-000004A1FBC8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 13:42 +0200, Roberto Sassu wrote: 
> On 10/02/2014 12:43 PM, Dmitry Kasatkin wrote:
> > On 02/10/14 13:06, Roberto Sassu wrote:
> >> On 10/02/2014 11:30 AM, Dmitry Kasatkin wrote:
> >>> On 02/10/14 11:26, Roberto Sassu wrote:
> >>>> On 10/01/2014 08:43 PM, Dmitry Kasatkin wrote:
> >>>>> ima_file_free() hook is only used by appraisal module to update hash
> >>>>> when file was modified. When there were no integrity checks on inode,
> >>>>> S_IMA flag is not set, integrity_iint_find() returns NULL and it
> >>>>> quits. When inode is only measured/audited but not appraised, iint
> >>>>> is allocated and it will cause calling ima_check_last_writer() which
> >>>>> unnecessarily locks i_mutex.
> >>>>>
> >>>>> Currently ima_file_free() checks 'iint_initialized'. But it looks that
> >>>>> it is a mistake and originally 'ima_appraise' had to be used instead.
> >>>>> In fact usage of 'iint_initialized' is completely unnecessary because
> >>>>> S_IMA flag would not be set if iint was not allocated.
> >>>>>
> >>>> Hi Dmitry
> >>>>
> >>>> sorry, I think there are two mistakes here.
> >>>>
> >>>> First, ima_file_free() is not used by the appraisal module only
> >>>> because, if a file has been written, also the IMA_MEASURED
> >>>> and IMA_AUDITED flags are cleared. Your patch prevents further
> >>>> measurements/audits if a file is modified.
> >>>>
> >>>> Second, the lock of i_mutex is necessary, as it protects the
> >>>> access to the fields of the 'integrity_iint_cache' structure.
> >>>>
> >>>> My suggestion is to provide a patch that fixes the commit a756024e
> >>>> of Mimi's 'next' branch. The patch should just replace the check
> >>>> of 'iint_initialized' with 'ima_policy_flag'. The removal of
> >>>> 'iint_initialized' could be done in a separate patch.
> >>>>
> >>>> Thanks
> >>>>
> >>>> Roberto Sassu
> >>>
> >>> Hi Roberto,
> >>>
> >>> You are right. Clearing flags slipped out from my eyes.
> >>> In such case we need to test entire flag as we do in other places.
> >>> But in such case the patch is more about remove iint_initialzed, because
> >>> S_IMA flag would not be set anyway.
> >>> I posted modified version.
> >>>
> >>
> >> Hi Dmitry
> >>
> >> thanks for the updated version. I would slightly modify the
> >> patch description by saying that your patch completes the switching
> >> to the 'ima_policy_flag' variable in the checks at the beginning
> >> of IMA functions, started with the commit a756024e.
> >>
> > Updated in my tree..
> >
> > http://git.kernel.org/cgit/linux/kernel/git/kasatkin/linux-digsig.git/commit/?h=ima-next&id=cddb34c121434c71c69cb14069252c3c61c6ae11
> >
> 
> Ok, thanks.
> 
> Acked-by: Roberto Sassu <roberto.sassu@polito.it>
> 
> Roberto Sassu

Thanks, Dmitry, Roberto.  The patch and update description looks good.
Please post the updated patch inline here on the mailing list.

thanks,

Mimi


> 
> > Dmitry
> >
> >> I noticed that James Morris pulled my previous patches, so also
> >> this one should be pulled after Mimi confirms that it is ok.
> >>
> >>
> >>>
> >>> This patch and other patches were posted a week ago on linux-ima-devel
> >>> mailing list.
> >>> I appreciate you would review patches when they come there so we could
> >>> spot more issues before they come to lsm mailing list.
> >>>
> >>
> >> Ok, sure.
> >>
> >> Thanks
> >>
> >> Roberto Sassu
> >>
> >>
> >>> Thanks,
> >>> Dmitry
> >>>
> >>>>
> >>>>> This patch uses lately introduced ima_policy_flag to test if appraisal
> >>>>> was enabled by policy.
> >>>>>
> >>>>> With this change 'iint_initialized' is no longer used anywhere.
> >>>>> Indeed,
> >>>>> integrity cache is allocated with SLAB_PANIC and kernel will panic if
> >>>>> allocation fails during kernel initialization. So this variable is
> >>>>> unnecessary and thus this patch removes it.
> >>>>>
> >>>>> Changes in v2:
> >>>>> * 'iint_initialized' removal patch merged to this patch (requested
> >>>>>       by Mimi)
> >>>>>
> >>>>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> >>>>> ---
> >>>>>     security/integrity/iint.c         | 3 ---
> >>>>>     security/integrity/ima/ima_main.c | 2 +-
> >>>>>     security/integrity/integrity.h    | 3 ---
> >>>>>     3 files changed, 1 insertion(+), 7 deletions(-)
> >>>>>
> >>>>> diff --git a/security/integrity/iint.c b/security/integrity/iint.c
> >>>>> index a521edf..cc3eb4d 100644
> >>>>> --- a/security/integrity/iint.c
> >>>>> +++ b/security/integrity/iint.c
> >>>>> @@ -25,8 +25,6 @@ static struct rb_root integrity_iint_tree = RB_ROOT;
> >>>>>     static DEFINE_RWLOCK(integrity_iint_lock);
> >>>>>     static struct kmem_cache *iint_cache __read_mostly;
> >>>>>
> >>>>> -int iint_initialized;
> >>>>> -
> >>>>>     /*
> >>>>>      * __integrity_iint_find - return the iint associated with an inode
> >>>>>      */
> >>>>> @@ -166,7 +164,6 @@ static int __init integrity_iintcache_init(void)
> >>>>>         iint_cache =
> >>>>>             kmem_cache_create("iint_cache", sizeof(struct
> >>>>> integrity_iint_cache),
> >>>>>                       0, SLAB_PANIC, init_once);
> >>>>> -    iint_initialized = 1;
> >>>>>         return 0;
> >>>>>     }
> >>>>>     security_initcall(integrity_iintcache_init);
> >>>>> diff --git a/security/integrity/ima/ima_main.c
> >>>>> b/security/integrity/ima/ima_main.c
> >>>>> index 62f59ec..87d7df7 100644
> >>>>> --- a/security/integrity/ima/ima_main.c
> >>>>> +++ b/security/integrity/ima/ima_main.c
> >>>>> @@ -143,7 +143,7 @@ void ima_file_free(struct file *file)
> >>>>>         struct inode *inode = file_inode(file);
> >>>>>         struct integrity_iint_cache *iint;
> >>>>>
> >>>>> -    if (!iint_initialized || !S_ISREG(inode->i_mode))
> >>>>> +    if (!(ima_policy_flag & IMA_APPRAISE) || !S_ISREG(inode->i_mode))
> >>>>>             return;
> >>>>>
> >>>>>         iint = integrity_iint_find(inode);
> >>>>> diff --git a/security/integrity/integrity.h
> >>>>> b/security/integrity/integrity.h
> >>>>> index aafb468..f51ad65 100644
> >>>>> --- a/security/integrity/integrity.h
> >>>>> +++ b/security/integrity/integrity.h
> >>>>> @@ -169,6 +169,3 @@ static inline void integrity_audit_msg(int
> >>>>> audit_msgno, struct inode *inode,
> >>>>>     {
> >>>>>     }
> >>>>>     #endif
> >>>>> -
> >>>>> -/* set during initialization */
> >>>>> -extern int iint_initialized;
> >>>>>
> >>>>
> >>>> ------------------------------------------------------------------------------
> >>>>
> >>>> Meet PCI DSS 3.0 Compliance Requirements with EventLog Analyzer
> >>>> Achieve PCI DSS 3.0 Compliant Status with Out-of-the-box PCI DSS
> >>>> Reports
> >>>> Are you Audit-Ready for PCI DSS 3.0 Compliance? Download White paper
> >>>> Comply to PCI DSS 3.0 Requirement 10 and 11.5 with EventLog Analyzer
> >>>> http://pubads.g.doubleclick.net/gampad/clk?id=154622311&iu=/4140/ostg.clktrk
> >>>>
> >>>> _______________________________________________
> >>>> Linux-ima-devel mailing list
> >>>> Linux-ima-devel@lists.sourceforge.net
> >>>> https://lists.sourceforge.net/lists/listinfo/linux-ima-devel
> >>>>
> >>>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> >> linux-security-module" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


