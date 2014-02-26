Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaBZQdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:33:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaBZQdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:33:42 -0500
Date: Wed, 26 Feb 2014 11:32:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 07/11] kexec: Create a relocatable object called purgatory
Message-ID: <20140226163256.GD23022@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-8-git-send-email-vgoyal@redhat.com>
 <20140226160008.GF22639@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226160008.GF22639@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 05:00:08PM +0100, Borislav Petkov wrote:

[..]
> > Also sha256_generic.c is supposed to work with higher level crypto
> > abstrations and API and there was no point in importing all that in
> > purgatory. So instead of doing #include on sha256_generic.c I just
> > copied relevant portions of code into arch/x86/purgatory/sha256.c. Now
> > we shouldn't have to touch this code at all. Do let me know if there are
> > better ways to handle it.
> 
> Ok, but what about configurable encryption algorithms? Maybe there are
> people who don't want to use sha-2 and prefer something else instead.

We have been using sha256 for last 7-8 years in kexec-tools and nobody
asked for changing hash algorithm so far.

So yes, somebody wanting to use a different algorithm is a possibility
but I don't think it is likely in near future.

This patchset is already very big. I would rather make it work with
sha256 and down the line one can make it more generic if they feel
the need. This is not a user space API/ABI and one should be able to
change it without breaking any user space applications.

So I really don't feel the need of making it more complicated, pull in
all the crypto API in purgaotry to support other kind of hash algorithms
in purgatory.

> 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Also checkpatch:
> 
> ...
> total: 429 errors, 5 warnings, 1409 lines checked

Will run checkpatch.

> 
> > diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> > index 13b22e0..fedcd16 100644
> > --- a/arch/x86/Makefile
> > +++ b/arch/x86/Makefile
> > @@ -160,6 +160,11 @@ archscripts: scripts_basic
> >  archheaders:
> >  	$(Q)$(MAKE) $(build)=arch/x86/syscalls all
> >  
> > +archprepare:
> > +ifeq ($(CONFIG_KEXEC),y)
> > +	$(Q)$(MAKE) $(build)=arch/x86/purgatory arch/x86/purgatory/kexec-purgatory.c
> > +endif
> 
> I wonder if this could be put into arch/x86/boot/ and built there too...
> But hpa said that already.

I thought hpa wanted to shared memcpy(), memset() and memcmp() functions
from arch/x86/. He did nto ask to move arch/x86/purgatory/ in
arch/x86/boot.

I personally felt that arch/x86/boot/ has all the code to build kernel
and purgaotry code does not deal with it. So I felt it is better to create
arch/x86/purgatory.

hpa, what do you think. Is there any strong reason that purgatory/ dir
 should be under arch/x86/boot/ and not under arch/x86/.

[..]
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> 
> Yeah, can we drop this boilerplate gunk and refer to COPYING instead.

Ok. Will do.

[..]
> > +	/* Load the registers */
> > +	movq	rax(%rip), %rax
> > +	movq	rbx(%rip), %rbx
> > +	movq	rcx(%rip), %rcx
> > +	movq	rdx(%rip), %rdx
> > +	movq	rsi(%rip), %rsi
> > +	movq	rdi(%rip), %rdi
> > +	movq    rsp(%rip), %rsp
> > +	movq	rbp(%rip), %rbp
> > +	movq	r8(%rip), %r8
> > +	movq	r9(%rip), %r9
> > +	movq	r10(%rip), %r10
> > +	movq	r11(%rip), %r11
> > +	movq	r12(%rip), %r12
> > +	movq	r13(%rip), %r13
> > +	movq	r14(%rip), %r14
> > +	movq	r15(%rip), %r15
> 
> Huh, is the purpose to simply clear the arch registers here?
> 
> 	xor %reg,%reg

No. One can modify purgatory object symbol entry64_regs dynamically from
outside and purpose of this code is to load values into registers. At
compile time value of entry64_regs is 0 so it kind of gives the impression
that we are just trying to zero registers.

At kernel load time, we set values of some of those registers. Stack and
kernel entry point is one of those. Look at
arch/x86/kernel/kexec-bzimage.c

        regs64.rbx = 0; /* Bootstrap Processor */
        regs64.rsi = bootparam_load_addr;
        regs64.rip = kernel_load_addr + 0x200;
	regs64.rsp = (unsigned long)stack;
	ret = kexec_purgatory_get_set_symbol(image, "entry64_regs", &regs64,
                                        sizeof(regs64), 0);

[..]
> > +int verify_sha256_digest(void)
> > +{
> > +	struct sha_region *ptr, *end;
> > +	u8 digest[SHA256_DIGEST_SIZE];
> > +	struct sha256_state sctx;
> > +
> > +	sha256_init(&sctx);
> > +	end = &sha_regions[sizeof(sha_regions)/sizeof(sha_regions[0])];
> > +	for (ptr = sha_regions; ptr < end; ptr++)
> > +		sha256_update(&sctx, (uint8_t *)(ptr->start), ptr->len);
> > +
> > +	sha256_final(&sctx, digest);
> > +
> > +	if (memcmp(digest, sha256_digest, sizeof(digest)) != 0)
> > +		return 1;
> > +
> > +        return 0;
> > +}
> > +
> > +void purgatory(void)
> > +{
> > +	int ret;
> > +
> > +	ret = verify_sha256_digest();
> 
> Yeah, again, hardcoding sha256 is kinda jucky. We probably should link
> the needed crypto API stuff stuff and support multiple encryption algos.

There is no easy way to link to kernel crypto API as purgatory object
does not link against kernel. Most likely it will have to be either a
common library against which both kernel and purgatory link or use
all the #include magic. I really don't want to make things complicated
here.

The purpose of this isolated code in a directory is that write it once
and almost never touch it again.

> 
> > +	if (ret) {
> > +		/* loop forever */
> > +		for(;;);
> > +	}
> > +	copy_backup_region();
> 
> What is this thing supposed to do? I see in patch 11/11
> arch_update_purgatory() does some preparations for KEXEC_TYPE_CRASH.

Kdump kernel runs from reserved region of memory. But we also found on
x86, that it still needed first 640KB of memory to boot. So before jumping
to second kernel, we copy first 640KB in reserved region and let second
kernel use first 640KB. We call this concept as backup region as we are
backing up an area of memory so that second kernel does not overwrite it.

For more details on backup region have a look at this paper.

http://lse.sourceforge.net/kdump/documentation/ols2oo5-kdump-paper.pdf
 
[..]
> > + */
> > +
> > +	.text
> > +	.globl purgatory_start
> > +	.balign 16
> > +purgatory_start:
> > +	.code32
> > +
> > +	/* This is just a stub. Write code when 32bit support comes along */
> 
> I'm guessing we want to support 32-bit secure boot with kexec at some
> point...

Yep. Right now these patches support 64bit kernel only and I put some
code for 32bit so that there are no compilation failures. 

Though 32bit is becoming less relevant with every passing day, still
supporting it on 32bit is a good idea. It can happen down the line tough.

[..]
> Bah, that's a huge patch - it could use some splitting.

I will see if I can find a way to split this patch. Thanks for reviewing
it.

Thanks
Vivek
