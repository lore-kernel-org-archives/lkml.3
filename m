Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbaIZPyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:54:04 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:57314 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaIZPyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:54:00 -0400
Date: Fri, 26 Sep 2014 16:53:56 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Joseph Poirier <jdpoirier@gmail.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH] partitions: efi.c: fix formatting and function
 readability
Message-ID: <20140926155356.GY18635@console-pimps.org>
References: <1409803640-9682-1-git-send-email-jdpoirier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409803640-9682-1-git-send-email-jdpoirier@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(No response from Davidlohr, try another address)

On Wed, 03 Sep, at 11:07:20PM, Joseph Poirier wrote:
> From: jpoirier <jdpoirier@gmail.com>
> 
> Fixed coding style issues, refactored the protective MBR check
> function for readability, and removed an explicit return from a
> function returning void.
> 
> Signed-off-by: Joseph Poirier <jdpoirier@gmail.com>
> Signed-off-by: jpoirier <jdpoirier@gmail.com>
> ---
>  block/partitions/efi.c | 222 ++++++++++++++++++++++++-------------------------
>  1 file changed, 110 insertions(+), 112 deletions(-)
> 
> diff --git a/block/partitions/efi.c b/block/partitions/efi.c
> index 56d08fd..21d0fcb 100644
> --- a/block/partitions/efi.c
> +++ b/block/partitions/efi.c
> @@ -37,7 +37,7 @@
>   * - Ported to 2.5.7-pre1 and 2.5.7-dj2
>   * - Applied patch to avoid fault in alternate header handling
>   * - cleaned up find_valid_gpt
> - * - On-disk structure and copy in memory is *always* LE now - 
> + * - On-disk structure and copy in memory is *always* LE now -
>   *   swab fields as needed
>   * - remove print_gpt_header()
>   * - only use first max_p partition entries, to keep the kernel minor number
> @@ -54,7 +54,7 @@
>   * - moved le_efi_guid_to_cpus() back into this file.  GPT is the only
>   *   thing that keeps EFI GUIDs on disk.
>   * - Changed gpt structure names and members to be simpler and more Linux-like.
> - * 
> + *
>   * Wed Oct 17 2001 Matt Domsch <Matt_Domsch@dell.com>
>   * - Removed CONFIG_DEVFS_VOLUMES_UUID code entirely per Martin Wilck
>   *
> @@ -79,7 +79,7 @@
>   *
>   * Wed Jun  6 2001 Martin Wilck <Martin.Wilck@Fujitsu-Siemens.com>
>   * - added devfs volume UUID support (/dev/volumes/uuids) for
> - *   mounting file systems by the partition GUID. 
> + *   mounting file systems by the partition GUID.
>   *
>   * Tue Dec  5 2000 Matt Domsch <Matt_Domsch@dell.com>
>   * - Moved crc32() to linux/lib, added efi_crc32().
> @@ -109,8 +109,7 @@
>   * the partition tables happens after init too.
>   */
>  static int force_gpt;
> -static int __init
> -force_gpt_fn(char *str)
> +static int __init force_gpt_fn(char *str)
>  {
>  	force_gpt = 1;
>  	return 1;
> @@ -124,14 +123,13 @@ __setup("gpt", force_gpt_fn);
>   * @len: length of buf
>   *
>   * Description: Returns EFI-style CRC32 value for @buf
> - * 
> + *
>   * This function uses the little endian Ethernet polynomial
>   * but seeds the function with ~0, and xor's with ~0 at the end.
>   * Note, the EFI Specification, v1.02, has a reference to
>   * Dr. Dobbs Journal, May 1994 (actually it's in May 1992).
>   */
> -static inline u32
> -efi_crc32(const void *buf, unsigned long len)
> +static inline u32 efi_crc32(const void *buf, unsigned long len)
>  {
>  	return (crc32(~0L, buf, len) ^ ~0L);
>  }
> @@ -139,7 +137,7 @@ efi_crc32(const void *buf, unsigned long len)
>  /**
>   * last_lba(): return number of last logical block of device
>   * @bdev: block device
> - * 
> + *
>   * Description: Returns last LBA value on success, 0 on error.
>   * This is stored (by sd and ide-geometry) in
>   *  the part[0] entry for this disk, and is the number of
> @@ -202,37 +200,35 @@ static int is_pmbr_valid(legacy_mbr *mbr, sector_t total_sectors)
>  			 * now check if there are other partition types for
>  			 * hybrid MBR.
>  			 */
> -			goto check_hybrid;
> +			break;
>  		}
>  	}
>  
> -	if (ret != GPT_MBR_PROTECTIVE)
> -		goto done;
> -check_hybrid:
> -	for (i = 0; i < 4; i++)
> -		if ((mbr->partition_record[i].os_type !=
> -			EFI_PMBR_OSTYPE_EFI_GPT) &&
> -		    (mbr->partition_record[i].os_type != 0x00))
> -			ret = GPT_MBR_HYBRID;
> -
> -	/*
> -	 * Protective MBRs take up the lesser of the whole disk
> -	 * or 2 TiB (32bit LBA), ignoring the rest of the disk.
> -	 * Some partitioning programs, nonetheless, choose to set
> -	 * the size to the maximum 32-bit limitation, disregarding
> -	 * the disk size.
> -	 *
> -	 * Hybrid MBRs do not necessarily comply with this.
> -	 *
> -	 * Consider a bad value here to be a warning to support dd'ing
> -	 * an image from a smaller disk to a larger disk.
> -	 */
>  	if (ret == GPT_MBR_PROTECTIVE) {
> +		for (i = 0; i < 4; i++)
> +			if ((mbr->partition_record[i].os_type !=
> +				EFI_PMBR_OSTYPE_EFI_GPT) &&
> +			    (mbr->partition_record[i].os_type != 0x00)) {
> +				ret = GPT_MBR_HYBRID;
> +				goto done;
> +			}
> +		/*
> +		 * Protective MBRs take up the lesser of the whole disk
> +		 * or 2 TiB (32bit LBA), ignoring the rest of the disk.
> +		 * Some partitioning programs, nonetheless, choose to set
> +		 * the size to the maximum 32-bit limitation, disregarding
> +		 * the disk size.
> +		 *
> +		 * Hybrid MBRs do not necessarily comply with this.
> +		 *
> +		 * Consider a bad value here to be a warning to support dd'ing
> +		 * an image from a smaller disk to a larger disk.
> +		 */
>  		sz = le32_to_cpu(mbr->partition_record[part].size_in_lba);
>  		if (sz != (uint32_t) total_sectors - 1 && sz != 0xFFFFFFFF)
> -			pr_debug("GPT: mbr size in lba (%u) different than whole disk (%u).\n",
> -				 sz, min_t(uint32_t,
> -					   total_sectors - 1, 0xFFFFFFFF));
> +			pr_debug("GPT: mbr size in lba (%u) different than "
> +				"whole disk (%u).\n", sz,
> +				min_t(uint32_t, total_sectors - 1, 0xFFFFFFFF));
>  	}
>  done:
>  	return ret;
> @@ -256,12 +252,13 @@ static size_t read_lba(struct parsed_partitions *state,
>  	sector_t n = lba * (bdev_logical_block_size(bdev) / 512);
>  
>  	if (!buffer || lba > last_lba(bdev))
> -                return 0;
> +		return 0;
>  
>  	while (count) {
>  		int copied = 512;
>  		Sector sect;
>  		unsigned char *data = read_part_sector(state, n++, &sect);
> +
>  		if (!data)
>  			break;
>  		if (copied > count)
> @@ -269,7 +266,7 @@ static size_t read_lba(struct parsed_partitions *state,
>  		memcpy(buffer, data, copied);
>  		put_dev_sector(sect);
>  		buffer += copied;
> -		totalreadcount +=copied;
> +		totalreadcount += copied;
>  		count -= copied;
>  	}
>  	return totalreadcount;
> @@ -279,7 +276,7 @@ static size_t read_lba(struct parsed_partitions *state,
>   * alloc_read_gpt_entries(): reads partition entries from disk
>   * @state: disk parsed partitions
>   * @gpt: GPT header
> - * 
> + *
>   * Description: Returns ptes on success,  NULL on error.
>   * Allocates space for PTEs based on information found in @gpt.
>   * Notes: remember to free pte when you're done!
> @@ -294,7 +291,7 @@ static gpt_entry *alloc_read_gpt_entries(struct parsed_partitions *state,
>  		return NULL;
>  
>  	count = le32_to_cpu(gpt->num_partition_entries) *
> -                le32_to_cpu(gpt->sizeof_partition_entry);
> +		le32_to_cpu(gpt->sizeof_partition_entry);
>  	if (!count)
>  		return NULL;
>  	pte = kmalloc(count, GFP_KERNEL);
> @@ -304,7 +301,7 @@ static gpt_entry *alloc_read_gpt_entries(struct parsed_partitions *state,
>  	if (read_lba(state, le64_to_cpu(gpt->partition_entry_lba),
>  			(u8 *) pte, count) < count) {
>  		kfree(pte);
> -                pte=NULL;
> +		pte = NULL;
>  		return NULL;
>  	}
>  	return pte;
> @@ -314,7 +311,7 @@ static gpt_entry *alloc_read_gpt_entries(struct parsed_partitions *state,
>   * alloc_read_gpt_header(): Allocates GPT header, reads into it from disk
>   * @state: disk parsed partitions
>   * @lba: the Logical Block Address of the partition table
> - * 
> + *
>   * Description: returns GPT header on success, NULL on error.   Allocates
>   * and fills a GPT header starting at @ from @state->bdev.
>   * Note: remember to free gpt when finished with it.
> @@ -331,7 +328,7 @@ static gpt_header *alloc_read_gpt_header(struct parsed_partitions *state,
>  
>  	if (read_lba(state, lba, (u8 *) gpt, ssz) < ssz) {
>  		kfree(gpt);
> -                gpt=NULL;
> +		gpt = NULL;
>  		return NULL;
>  	}
>  
> @@ -361,7 +358,7 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
>  
>  	/* Check the GUID Partition Table signature */
>  	if (le64_to_cpu((*gpt)->signature) != GPT_HEADER_SIGNATURE) {
> -		pr_debug("GUID Partition Table Header signature is wrong:"
> +		pr_debug("GUID Partition Table Header signature is wrong: "
>  			 "%lld != %lld\n",
>  			 (unsigned long long)le64_to_cpu((*gpt)->signature),
>  			 (unsigned long long)GPT_HEADER_SIGNATURE);
> @@ -388,7 +385,8 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
>  	/* Check the GUID Partition Table CRC */
>  	origcrc = le32_to_cpu((*gpt)->header_crc32);
>  	(*gpt)->header_crc32 = 0;
> -	crc = efi_crc32((const unsigned char *) (*gpt), le32_to_cpu((*gpt)->header_size));
> +	crc = efi_crc32((const unsigned char *) (*gpt),
> +			le32_to_cpu((*gpt)->header_size));
>  
>  	if (crc != origcrc) {
>  		pr_debug("GUID Partition Table Header CRC is wrong: %x != %x\n",
> @@ -412,20 +410,21 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
>  	lastlba = last_lba(state->bdev);
>  	if (le64_to_cpu((*gpt)->first_usable_lba) > lastlba) {
>  		pr_debug("GPT: first_usable_lba incorrect: %lld > %lld\n",
> -			 (unsigned long long)le64_to_cpu((*gpt)->first_usable_lba),
> -			 (unsigned long long)lastlba);
> +			(unsigned long long)le64_to_cpu((*gpt)->first_usable_lba),
> +			(unsigned long long)lastlba);
>  		goto fail;
>  	}
>  	if (le64_to_cpu((*gpt)->last_usable_lba) > lastlba) {
>  		pr_debug("GPT: last_usable_lba incorrect: %lld > %lld\n",
> -			 (unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
> -			 (unsigned long long)lastlba);
> +			(unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
> +			(unsigned long long)lastlba);
>  		goto fail;
>  	}
> -	if (le64_to_cpu((*gpt)->last_usable_lba) < le64_to_cpu((*gpt)->first_usable_lba)) {
> +	if (le64_to_cpu((*gpt)->last_usable_lba) <
> +			le64_to_cpu((*gpt)->first_usable_lba)) {
>  		pr_debug("GPT: last_usable_lba incorrect: %lld > %lld\n",
> -			 (unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
> -			 (unsigned long long)le64_to_cpu((*gpt)->first_usable_lba));
> +			(unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
> +			(unsigned long long)le64_to_cpu((*gpt)->first_usable_lba));
>  		goto fail;
>  	}
>  	/* Check that sizeof_partition_entry has the correct value */
> @@ -466,8 +465,7 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
>   *
>   * Description: returns 1 if valid,  0 on error.
>   */
> -static inline int
> -is_pte_valid(const gpt_entry *pte, const u64 lastlba)
> +static inline int is_pte_valid(const gpt_entry *pte, const u64 lastlba)
>  {
>  	if ((!efi_guidcmp(pte->partition_type_guid, NULL_GUID)) ||
>  	    le64_to_cpu(pte->starting_lba) > lastlba         ||
> @@ -484,42 +482,42 @@ is_pte_valid(const gpt_entry *pte, const u64 lastlba)
>   *
>   * Description: Returns nothing.  Sanity checks pgpt and agpt fields
>   * and prints warnings on discrepancies.
> - * 
> + *
>   */
> -static void
> -compare_gpts(gpt_header *pgpt, gpt_header *agpt, u64 lastlba)
> +static void compare_gpts(gpt_header *pgpt, gpt_header *agpt, u64 lastlba)
>  {
>  	int error_found = 0;
> +
>  	if (!pgpt || !agpt)
>  		return;
>  	if (le64_to_cpu(pgpt->my_lba) != le64_to_cpu(agpt->alternate_lba)) {
>  		pr_warn("GPT:Primary header LBA != Alt. header alternate_lba\n");
>  		pr_warn("GPT:%lld != %lld\n",
> -		       (unsigned long long)le64_to_cpu(pgpt->my_lba),
> -                       (unsigned long long)le64_to_cpu(agpt->alternate_lba));
> +			(unsigned long long)le64_to_cpu(pgpt->my_lba),
> +			(unsigned long long)le64_to_cpu(agpt->alternate_lba));
>  		error_found++;
>  	}
>  	if (le64_to_cpu(pgpt->alternate_lba) != le64_to_cpu(agpt->my_lba)) {
>  		pr_warn("GPT:Primary header alternate_lba != Alt. header my_lba\n");
>  		pr_warn("GPT:%lld != %lld\n",
> -		       (unsigned long long)le64_to_cpu(pgpt->alternate_lba),
> -                       (unsigned long long)le64_to_cpu(agpt->my_lba));
> +			(unsigned long long)le64_to_cpu(pgpt->alternate_lba),
> +			(unsigned long long)le64_to_cpu(agpt->my_lba));
>  		error_found++;
>  	}
>  	if (le64_to_cpu(pgpt->first_usable_lba) !=
> -            le64_to_cpu(agpt->first_usable_lba)) {
> +			le64_to_cpu(agpt->first_usable_lba)) {
>  		pr_warn("GPT:first_usable_lbas don't match.\n");
>  		pr_warn("GPT:%lld != %lld\n",
> -		       (unsigned long long)le64_to_cpu(pgpt->first_usable_lba),
> -                       (unsigned long long)le64_to_cpu(agpt->first_usable_lba));
> +			(unsigned long long)le64_to_cpu(pgpt->first_usable_lba),
> +			(unsigned long long)le64_to_cpu(agpt->first_usable_lba));
>  		error_found++;
>  	}
>  	if (le64_to_cpu(pgpt->last_usable_lba) !=
> -            le64_to_cpu(agpt->last_usable_lba)) {
> +			le64_to_cpu(agpt->last_usable_lba)) {
>  		pr_warn("GPT:last_usable_lbas don't match.\n");
>  		pr_warn("GPT:%lld != %lld\n",
> -		       (unsigned long long)le64_to_cpu(pgpt->last_usable_lba),
> -                       (unsigned long long)le64_to_cpu(agpt->last_usable_lba));
> +			(unsigned long long)le64_to_cpu(pgpt->last_usable_lba),
> +			(unsigned long long)le64_to_cpu(agpt->last_usable_lba));
>  		error_found++;
>  	}
>  	if (efi_guidcmp(pgpt->disk_guid, agpt->disk_guid)) {
> @@ -527,27 +525,26 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, u64 lastlba)
>  		error_found++;
>  	}
>  	if (le32_to_cpu(pgpt->num_partition_entries) !=
> -            le32_to_cpu(agpt->num_partition_entries)) {
> -		pr_warn("GPT:num_partition_entries don't match: "
> -		       "0x%x != 0x%x\n",
> -		       le32_to_cpu(pgpt->num_partition_entries),
> -		       le32_to_cpu(agpt->num_partition_entries));
> +			le32_to_cpu(agpt->num_partition_entries)) {
> +		pr_warn("GPT:num_partition_entries don't match: 0x%x != 0x%x\n",
> +			le32_to_cpu(pgpt->num_partition_entries),
> +			le32_to_cpu(agpt->num_partition_entries));
>  		error_found++;
>  	}
>  	if (le32_to_cpu(pgpt->sizeof_partition_entry) !=
> -            le32_to_cpu(agpt->sizeof_partition_entry)) {
> +			le32_to_cpu(agpt->sizeof_partition_entry)) {
>  		pr_warn("GPT:sizeof_partition_entry values don't match: "
> -		       "0x%x != 0x%x\n",
> -                       le32_to_cpu(pgpt->sizeof_partition_entry),
> -		       le32_to_cpu(agpt->sizeof_partition_entry));
> +			"0x%x != 0x%x\n",
> +			le32_to_cpu(pgpt->sizeof_partition_entry),
> +			le32_to_cpu(agpt->sizeof_partition_entry));
>  		error_found++;
>  	}
>  	if (le32_to_cpu(pgpt->partition_entry_array_crc32) !=
> -            le32_to_cpu(agpt->partition_entry_array_crc32)) {
> +			le32_to_cpu(agpt->partition_entry_array_crc32)) {
>  		pr_warn("GPT:partition_entry_array_crc32 values don't match: "
> -		       "0x%x != 0x%x\n",
> -                       le32_to_cpu(pgpt->partition_entry_array_crc32),
> -		       le32_to_cpu(agpt->partition_entry_array_crc32));
> +			"0x%x != 0x%x\n",
> +			le32_to_cpu(pgpt->partition_entry_array_crc32),
> +			le32_to_cpu(agpt->partition_entry_array_crc32));
>  		error_found++;
>  	}
>  	if (le64_to_cpu(pgpt->alternate_lba) != lastlba) {
> @@ -568,7 +565,6 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, u64 lastlba)
>  
>  	if (error_found)
>  		pr_warn("GPT: Use GNU Parted to correct GPT errors.\n");
> -	return;
>  }
>  
>  /**
> @@ -601,7 +597,7 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
>  		return 0;
>  
>  	lastlba = last_lba(state->bdev);
> -        if (!force_gpt) {
> +	if (!force_gpt) {
>  		/* This will be added to the EFI Spec. per Intel after v1.02. */
>  		legacymbr = kzalloc(sizeof(*legacymbr), GFP_KERNEL);
>  		if (!legacymbr)
> @@ -621,46 +617,45 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
>  
>  	good_pgpt = is_gpt_valid(state, GPT_PRIMARY_PARTITION_TABLE_LBA,
>  				 &pgpt, &pptes);
> -        if (good_pgpt)
> +	if (good_pgpt)
>  		good_agpt = is_gpt_valid(state,
>  					 le64_to_cpu(pgpt->alternate_lba),
>  					 &agpt, &aptes);
> -        if (!good_agpt && force_gpt)
> -                good_agpt = is_gpt_valid(state, lastlba, &agpt, &aptes);
> +	if (!good_agpt && force_gpt)
> +		good_agpt = is_gpt_valid(state, lastlba, &agpt, &aptes);
>  
> -        /* The obviously unsuccessful case */
> -        if (!good_pgpt && !good_agpt)
> -                goto fail;
> +	/* The obviously unsuccessful case */
> +	if (!good_pgpt && !good_agpt)
> +		goto fail;
>  
> -        compare_gpts(pgpt, agpt, lastlba);
> +	compare_gpts(pgpt, agpt, lastlba);
>  
> -        /* The good cases */
> -        if (good_pgpt) {
> -                *gpt  = pgpt;
> -                *ptes = pptes;
> -                kfree(agpt);
> -                kfree(aptes);
> +	/* The good cases */
> +	if (good_pgpt) {
> +		*gpt = pgpt;
> +		*ptes = pptes;
> +		kfree(agpt);
> +		kfree(aptes);
>  		if (!good_agpt)
> -                        pr_warn("Alternate GPT is invalid, using primary GPT.\n");
> -                return 1;
> -        }
> -        else if (good_agpt) {
> -                *gpt  = agpt;
> -                *ptes = aptes;
> -                kfree(pgpt);
> -                kfree(pptes);
> +			pr_warn("Alternate GPT is invalid, using primary GPT.\n");
> +		return 1;
> +	} else if (good_agpt) {
> +		*gpt  = agpt;
> +		*ptes = aptes;
> +		kfree(pgpt);
> +		kfree(pptes);
>  		pr_warn("Primary GPT is invalid, using alternate GPT.\n");
> -                return 1;
> -        }
> +		return 1;
> +	}
>  
>   fail:
> -        kfree(pgpt);
> -        kfree(agpt);
> -        kfree(pptes);
> -        kfree(aptes);
> -        *gpt = NULL;
> -        *ptes = NULL;
> -        return 0;
> +	kfree(pgpt);
> +	kfree(agpt);
> +	kfree(pptes);
> +	kfree(aptes);
> +	*gpt = NULL;
> +	*ptes = NULL;
> +	return 0;
>  }
>  
>  /**
> @@ -697,7 +692,8 @@ int efi_partition(struct parsed_partitions *state)
>  
>  	pr_debug("GUID Partition Table is valid!  Yea!\n");
>  
> -	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1; i++) {
> +	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) &&
> +			i < state->limit-1; i++) {
>  		struct partition_meta_info *info;
>  		unsigned label_count = 0;
>  		unsigned label_max;
> @@ -711,7 +707,8 @@ int efi_partition(struct parsed_partitions *state)
>  		put_partition(state, i+1, start * ssz, size * ssz);
>  
>  		/* If this is a RAID volume, tell md */
> -		if (!efi_guidcmp(ptes[i].partition_type_guid, PARTITION_LINUX_RAID_GUID))
> +		if (!efi_guidcmp(ptes[i].partition_type_guid,
> +				PARTITION_LINUX_RAID_GUID))
>  			state->parts[i + 1].flags = ADDPART_FLAG_RAID;
>  
>  		info = &state->parts[i + 1].info;
> @@ -723,6 +720,7 @@ int efi_partition(struct parsed_partitions *state)
>  		info->volname[label_max] = 0;
>  		while (label_count < label_max) {
>  			u8 c = ptes[i].partition_name[label_count] & 0xff;
> +
>  			if (c && !isprint(c))
>  				c = '!';
>  			info->volname[label_count] = c;
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matt Fleming, Intel Open Source Technology Center
