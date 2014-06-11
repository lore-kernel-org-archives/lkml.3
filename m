Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaFKTZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:25:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbaFKTZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:25:39 -0400
Date: Wed, 11 Jun 2014 15:24:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 10/13] kexec: Load and Relocate purgatory at kernel load
 time
Message-ID: <20140611192448.GH10723@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-11-git-send-email-vgoyal@redhat.com>
 <20140610163128.GA6652@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610163128.GA6652@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 06:31:28PM +0200, Borislav Petkov wrote:

[..]
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 213308a..0f24b61 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1556,6 +1556,8 @@ source kernel/Kconfig.hz
> >  config KEXEC
> >  	bool "kexec system call"
> >  	select BUILD_BIN2C
> > +	select CRYPTO
> > +	select CRYPTO_SHA256
> 
> Ok, but why automatically enable crypto? There's still the old kexec
> method where we don't check any signatures.

Hi Boris,

Thanks for reviewing the patches.

This new syscall requires sha256 even if signature checking does not
happen. Purgatory verifies checksum of segments.

I had to select CRYPTO also otherwise CONFIG_CRYPTO=m broke the build.

> 
> Which begs the more important question - shouldn't this new in-kernel
> loading method support also kexec'ing of kernels without any signature
> verifications at all?

I think yes it should allow kexecing kernels without any signature also.
In fact in long term, we should deprecate the old syscall and maintain
this new one.

Now, when does signature checking kick in? I think we can define a new
config option say KEXEC_ENFORCE_KERNEL_SIG_VERIFICATION. This option
will make sure kernel signature are verified. 

If KEXEC_ENFORCE_KERNEL_SIG_VERIFICATION=n, even then signature
verification should be enforced if secureboot is enabled on the platform.

As signature verification is not part of this series, I was planning to
post these changes as part of next series.

> 
> I mean, the main use case is secure boot and all but why not leave it
> configurable for people to decide?

I will make it configurable in next series. This series does not do
any signature verification yet. Above CRYPTO and CRYPTO_SHA256 I had
to select to make sure checksum verfication logic in purgatory works
fine.


[..]
> > +/* Apply purgatory relocations */
> > +int arch_kexec_apply_relocations_add(Elf64_Shdr *sechdrs,
> 
> apply_..._add? "arch_kexec_apply_relocations" seems fine to me.

Hmmm.., not sure why I did this. I will change it (until and unless find
a good reason for doing this).

[..]
> > +		case R_X86_64_PC32:
> > +			value -= (u64)address;
> > +			*(u32 *)location = value;
> > +			break;
> > +		default:
> > +			pr_err("kexec: Unknown rela relocation: %llu\n",
> 
> Yep, the "kexec: " string should come from pr_fmt as in the other mail.

Sure. Will use pr_fmt to prefix "kexec" string.

> 
> > +					ELF64_R_TYPE(rel[i].r_info));
> > +			return -ENOEXEC;
> > +		}
> > +	}
> > +	return 0;
> > +
> > +overflow:
> > +	pr_err("kexec: overflow in relocation type %d value 0x%lx\n",
> 
> Ditto.

Will do.

[..]
> >  struct kimage {
> >  	kimage_entry_t head;
> >  	kimage_entry_t *entry;
> > @@ -143,6 +165,9 @@ struct kimage {
> >  
> >  	/* Image loader handling the kernel can store a pointer here */
> >  	void *image_loader_data;
> > +
> > +	/* Information for loading purgatory */
> > +	struct purgatory_info purgatory_info;
> 
> Having the member name with the same name as the struct is kinda
> confusing. Also, you could shorten it, which, in turn, would give
> shorter code lines at the sites it is accessed. I.e.,
> 
> 	struct purgatory_info pinfo;
> 
> should be just fine IMHO.

Hmm... I have seen at other places using same name as structure. But I am
not particular about it will change. Anyway, on most of the places
I use a pointer to access it.

struct purgaotry_info *pi  = &image->purgatory_info;

[..]
> > +/* Apply relocations for rela section */
> > +int __attribute__ ((weak))
> > +arch_kexec_apply_relocations_add(Elf_Shdr *sechdrs, unsigned int nr_sections,
> > +					unsigned int relsec)
> > +{
> > +	pr_err(KERN_ERR "kexec: REL relocation unsupported\n");
> 
> pr_err *and* KERN_ERR. Double error level? :-)

Yep. Will fix it. :-)

> 
> > +	return -ENOEXEC;
> > +}
> > +
> >  /*
> >   * Free up tempory buffers allocated which are not needed after image has
> >   * been loaded.
> > @@ -355,6 +376,12 @@ static void kimage_file_post_load_cleanup(struct kimage *image)
> >  	vfree(image->cmdline_buf);
> >  	image->cmdline_buf = NULL;
> >  
> > +	vfree(image->purgatory_info.purgatory_buf);
> > +	image->purgatory_info.purgatory_buf = NULL;
> 
> Here's what I mean - that's definitely too long. Maybe

Sure will change it.

> 
> 	vree(image->pinfo.pbuf);
> 	image->pinfo.pbuf = NULL;
> 
> (yep, we shortened purgatory_buf too). Now this looks like proper kernel
> code to me :-)

I would like to retain purgaotry_buf. To shorten it I could do this.

	struct purgatory_info *pi = &image->purgatory_info;
	vfree(pi->purgatory_buf);
	pi->purgatory_buf = NULL;

I like the clarity in variable names.


> 
> > +
> > +	vfree(image->purgatory_info.sechdrs);
> > +	image->purgatory_info.sechdrs = NULL;
> > +
> >  	/* See if architcture has anything to cleanup post load */
> >  	arch_kimage_file_post_load_cleanup(image);
> >  }
> > @@ -1370,6 +1397,10 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
> >  	if (ret)
> >  		goto out;
> >  
> > +	ret = kexec_calculate_store_digests(image);
> 
> This function name could be shortened too: kexec_calc_digests() or so.
> The actual storing could be a separate kexec_store_digests. I.e., a
> function does one thing only.

I would like to keep it one function. Reason being that apart from
digest, we also store the list of regions which has been checkummed. And
you will notice that we skip the purgatory region during checksum
calculation.

So I will have to return quite some information from calc() function. Size
of digest, actual digest buffer which will need to be freed by caller,
and list of sha regions which will need to be freed by caller. Keeping
it call in one function makes it little simpler actually.


[..]
> > +/* Calculate and store the digest of segments */
> > +static int kexec_calculate_store_digests(struct kimage *image)
> > +{
> > +	struct crypto_shash *tfm;
> > +	struct shash_desc *desc;
> > +	int ret = 0, i, j, zero_buf_sz = 256, sha_region_sz;
> 
> 256 - a magic constant.

Just wanted a small zero buffer. Is there any global zero buffer available
in kernel. If not, I could use a PAGE_SIZE zero buffer instead.

> 
> > +	size_t desc_size, nullsz;
> > +	char *digest = NULL;
> > +	void *zero_buf;
> > +	struct kexec_sha_region *sha_regions;
> > +
> > +	tfm = crypto_alloc_shash("sha256", 0, 0);
> > +	if (IS_ERR(tfm)) {
> > +		ret = PTR_ERR(tfm);
> > +		goto out;
> 
> The "out" label kfrees digest but we haven't allocated it yet...

kfree() can handle NULL and digest is initialized to null.

> 
> > +	}
> > +
> > +	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
> > +	desc = kzalloc(desc_size, GFP_KERNEL);
> > +	if (!desc) {
> > +		ret = -ENOMEM;
> > +		goto out_free_tfm;
> > +	}
> > +
> > +	zero_buf = kzalloc(zero_buf_sz, GFP_KERNEL);
> > +	if (!zero_buf) {
> > +		ret = -ENOMEM;
> > +		goto out_free_desc;
> > +	}
> > +
> > +	sha_region_sz = KEXEC_SEGMENT_MAX * sizeof(struct kexec_sha_region);
> > +	sha_regions = vzalloc(sha_region_sz);
> > +	if (!sha_regions)
> > +		goto out_free_zero_buf;
> > +
> > +	desc->tfm   = tfm;
> > +	desc->flags = 0;
> > +
> > +	ret = crypto_shash_init(desc);
> > +	if (ret < 0)
> > +		goto out_free_sha_regions;
> > +
> > +	digest = kzalloc(SHA256_DIGEST_SIZE, GFP_KERNEL);
> > +	if (!digest) {
> > +		ret = -ENOMEM;
> > +		goto out_free_sha_regions;
> > +	}
> 
> ... but this digest is a simple allocation. Could it be you moved it
> down but forgot to readjust the labels?

I see what you are saying. I will fix the allocation ordering and lable
ordering. 

> 
> > +
> > +	/* Traverse through all segments */
> 
> Yep, we can see that. Why does it need an explicit comment?

Will remove.

> 
> > +	for (j = i = 0; i < image->nr_segments; i++) {
> > +		struct kexec_segment *ksegment;
> > +		ksegment = &image->segment[i];
> > +
> > +		/*
> > +		 * Skip purgatory as it will be modified once we put digest
> > +		 * info in purgatory
> > +		 */
> 
> Now this comment is perfect right there! :-) It needs a full-stop though.

Will do.

> 
> > +		if (ksegment->kbuf == image->purgatory_info.purgatory_buf)
> > +			continue;
> > +
> > +		ret = crypto_shash_update(desc, ksegment->kbuf,
> > +						ksegment->bufsz);
> 
> Arg alignment.

Will do.

> 
> > +		if (ret)
> > +			break;
> > +
> > +		nullsz = ksegment->memsz - ksegment->bufsz;
> > +		while (nullsz) {
> > +			unsigned long bytes = nullsz;
> > +			if (bytes > zero_buf_sz)
> > +				bytes = zero_buf_sz;
> > +			ret = crypto_shash_update(desc, zero_buf, bytes);
> > +			if (ret)
> > +				break;
> > +			nullsz -= bytes;
> > +		}
> 
> Now this trailing buffer "drainage" could very well use a comment on
> what's going on.

Sure, will put a comment.

> 
> > +
> > +		if (ret)
> > +			break;
> > +
> > +		sha_regions[j].start = ksegment->mem;
> > +		sha_regions[j].len = ksegment->memsz;
> > +		j++;
> > +	}
> > +
> > +	if (!ret) {
> > +		ret = crypto_shash_final(desc, digest);
> > +		if (ret)
> > +			goto out_free_sha_regions;
> > +		ret = kexec_purgatory_get_set_symbol(image, "sha_regions",
> > +				sha_regions, sha_region_sz, 0);
> > +		if (ret)
> > +			goto out_free_sha_regions;
> > +
> > +		ret = kexec_purgatory_get_set_symbol(image, "sha256_digest",
> > +				digest, SHA256_DIGEST_SIZE, 0);
> > +		if (ret)
> > +			goto out_free_sha_regions;
> 
> Yeah, this block could be a separate kexec_store_digests() function.

As explained above, splitting it out in a separate function requires
carrying atleast two pointers and their sizes. And these pointers will need to
be freed by store() functions. I guess keeping it right here is simpler.

> 
> > +	}
> > +
> > +out_free_sha_regions:
> > +	vfree(sha_regions);
> > +out_free_zero_buf:
> > +	kfree(zero_buf);
> > +out_free_desc:
> > +	kfree(desc);
> > +out_free_tfm:
> > +	kfree(tfm);
> > +out:
> > +	kfree(digest);
> > +	return ret;
> > +}
> > +
> > +/* Actually load and relcoate purgatory. Lot of code taken from kexec-tools */
> 
> s/relcoate/relocate/

Will fix.

> 
> > +static int elf_rel_load_relocate(struct kimage *image, unsigned long min,
> > +				unsigned long max, int top_down)
> 
> Another function which is too big and does at least two things and could
> probably be nicely split into two.
> 
> > +{
> > +	struct purgatory_info *pi = &image->purgatory_info;
> > +	unsigned long align, buf_align, bss_align, buf_sz, bss_sz, bss_pad;
> > +	unsigned long memsz, entry, load_addr, data_addr, bss_addr, off;
> > +	unsigned char *buf_addr, *src;
> > +	int i, ret = 0, entry_sidx = -1;
> > +	Elf_Shdr *sechdrs = NULL, *sechdrs_c;
> > +	void *purgatory_buf = NULL;
> > +
> > +	/*
> > +	 * sechdrs_c points to section headers in purgatory and are read
> > +	 * only. No modifications allowed.
> > +	 */
> 
> Then do
> 
> 	const Elf_Shdr * const sechdrs_c = (void *)pi->ehdr + pi->ehdr->e_shoff;
> 
> to enforce it?

Ok, will try to use it.

> 
> > +	sechdrs_c = (void *)pi->ehdr + pi->ehdr->e_shoff;
> > +
> > +	/*
> > +	 * We can not modify sechdrs_c[] and its fields. It is read only.
> > +	 * Copy it over to a local copy where one can store some temporary
> > +	 * data and free it at the end. We need to modify ->sh_addr and
> 
> What is freeing it when we store it into pi->sechdrs and return? Or
> doesn't it need to be freed?

kimage_file_post_load_cleanup() takes care of freeing it up. Till then
we need to keep this information around.

> 
> > +	 * ->sh_offset fields to keep track permanent and temporary locations
> > +	 * of sections.
> > +	 */
> > +	sechdrs = vzalloc(pi->ehdr->e_shnum * sizeof(Elf_Shdr));
> > +	if (!sechdrs)
> > +		return -ENOMEM;
> > +
> > +	memcpy(sechdrs, sechdrs_c, pi->ehdr->e_shnum * sizeof(Elf_Shdr));
> > +
> > +	/*
> > +	 * We seem to have multiple copies of sections. First copy is which
> > +	 * is embedded in kernel in read only section. Some of these sections
> > +	 * will be copied to a temporary buffer and relocated. And these
> > +	 * sections will finally be copied to their final detination at
> 
> "destination"

Will fix.


[..]
> > +	/* Add buffer to segment list */
> > +	ret = kexec_add_buffer(image, purgatory_buf, buf_sz, memsz,
> > +				buf_align, min, max, top_down,
> > +				&pi->purgatory_load_addr);
> > +	if (ret)
> > +		goto out;
> > +
> > +	/* Load SHF_ALLOC sections */
> 
> Here could start a new function.

I can try but I think there is too much of context information which
will need to be passed through function parameters.

[..]
> > +	/* update entry based on entry section position */
> > +	if (entry_sidx >= 0)
> > +		entry += sechdrs[entry_sidx].sh_addr;
> > +
> > +	/* Set the entry point of purgatory */
> > +	image->start = entry;
> > +
> > +	/* Apply relocations */
> 
> >From here-on could start a new function.

You seem to be asking to make three functions, parse(), load() and
relocate(). Aagain, I will have a closer look again and see if it
easily doable. My feeling is that they are very tightly coupled and
will need many function parameters.

[..]
> > +	for (i = 0; i < ehdr->e_shnum; i++) {
> > +		if (sechdrs[i].sh_type != SHT_SYMTAB)
> > +			continue;
> > +
> > +		if (sechdrs[i].sh_link > ehdr->e_shnum)
> > +			/* Invalid stratab section number */
> 
> "strtab"

Will Fix.

[..]
> > +int kexec_purgatory_get_set_symbol(struct kimage *image, const char *name,
> > +				void *buf, unsigned int size, bool get_value)
> > +{
> > +	Elf_Sym *sym;
> > +	Elf_Shdr *sechdrs;
> > +	struct purgatory_info *pi = &image->purgatory_info;
> > +	char *sym_buf;
> > +
> > +	sym = kexec_purgatory_find_symbol(pi, name);
> > +	if (!sym)
> > +		return -EINVAL;
> > +
> > +	if (sym->st_size != size) {
> > +		pr_debug("Symbol: %s size is not right\n", name);
> 
> Should probably be pr_err because it is an error, right? And then
> 
> 	pr_err("Symbol %s size mismatch: %d vs %d\n", name, sym->st_size, size);

It is an error, that's why I return -EINVAL. We are always not verbose
for all the errors. I kind of felt that it does not have to be of type
KERN_ERR. But I don't feel strongly about it. Will change it to pr_err().

Also will include additional information about expected size and actual
size.

> 
> > +		return -EINVAL;
> > +	}
> > +
> > +	sechdrs = pi->sechdrs;
> > +
> > +	if (sechdrs[sym->st_shndx].sh_type == SHT_NOBITS) {
> > +		pr_debug("Symbol: %s is in a bss section. Cannot get/set\n",
> 
> 			... Cannot %s\n", (get_value ? "get" : "set"), name);

Will do.

Thanks
Vivek
