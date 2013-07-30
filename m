Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab3G3XNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 19:13:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700Ab3G3XNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 19:13:17 -0400
Date: Tue, 30 Jul 2013 16:13:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Caizhiyong <caizhiyong@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>,
        Quyaxin <quyaxin@huawei.com>
Subject: Re: [PATCH] block: support embedded device command line partition
Message-Id: <20130730161315.e9d6c798214e6ccf85409777@linux-foundation.org>
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C06195E@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C06195E@szxeml512-mbs.china.huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jul 2013 13:56:24 +0000 Caizhiyong <caizhiyong@huawei.com> wrote:

> From: Cai Zhiyong <caizhiyong@huawei.com>
> 
> Read block device partition table from command line. This partition used for fixed block device (eMMC) embedded device.
> It no MBR, can save storage space. Bootloader can be easily accessed by absolute address of data on the block device. It support partition name, provides partition interface.

That seems a reasonable thing to be able to do.

> This code reference MTD partition, source "./drivers/mtd/cmdlinepart.c"
> The format for the command line is just like mtdparts.
> 
> Examples: eMMC disk name is "mmcblk0"
> bootargs 'cmdlineparts=mmcblk0:1G(data0),1G(data1),-;mmcblk0boot0:1m(boot),-(kernel)'

We should document this user interface properly.  Is there
documentation under Documentation/ which can be referenced?  If not,
something new should be created.

>
> ...
>
> +struct cmdline_parts {
> +	char name[BDEVNAME_SIZE]; /* block device, such as 'mmcblk0' */
> +	struct cmdline_subpart *subpart;
> +	struct cmdline_parts *next_parts;
> +};
> +
> +static DEFINE_MUTEX(cmdline_string_mutex);
> +
> +static char cmdline_string[512] = { 0 }; static struct cmdline_parts 
> +*cmdline_parts;

That's messed up.

> +static int parse_subpart(struct cmdline_subpart **subpart, char
> +*cmdline) {

Please convert all the function definitions to standard kernel style:

static int parse_subpart(struct cmdline_subpart **subpart, char *cmdline)
{

> +	int ret = 0;
> +	struct cmdline_subpart *new_subpart;
> +
> +	(*subpart) = NULL;
> +
> +	new_subpart = kzalloc(sizeof(struct cmdline_subpart), GFP_KERNEL);
> +	if (!new_subpart)
> +		return -ENOMEM;
> +
> +	if ((*cmdline) == '-') {
> +		new_subpart->size = SIZE_REMAINING;
> +		cmdline++;
> +	} else {
> +		new_subpart->size = memparse(cmdline, &cmdline);
> +		if (new_subpart->size < PAGE_SIZE) {
> +			pr_warn("cmdline partition size is invalid.");
> +			ret = -EFAULT;

EFAULT is inappropriate here.  EINVAL would be suitable.

> +			goto fail;
> +		}
> +	}
> +
> +	if ((*cmdline) == '@') {
> +		cmdline++;
> +		new_subpart->from = memparse(cmdline, &cmdline);
> +	} else {
> +		new_subpart->from = OFFSET_CONTINUOUS;
> +	}
> +
> +	if ((*cmdline) == '(') {
> +

Remove this newline.

> +		int length;
> +		char *next = strchr(++cmdline, ')');
> +
> +		if (!next) {
> +			pr_warn("cmdline partition format is invalid.");
> +			ret = -EFAULT;

EINVAL

> +			goto fail;
> +		}
> +
> +		length = min((int)(next - cmdline),
> +			     (int)(sizeof(new_subpart->name) - 1));

OK, that's pretty ghastly.

Ideally, the types of the various variable should be compatible, so no
casting is needed.

If that is really truly not practical then use min_t rather than
open-coding the casts.

> +		strncpy(new_subpart->name, cmdline, length);
> +		new_subpart->name[length] = '\0';
> +
> +		cmdline = ++next;
> +	} else
> +		new_subpart->name[0] = '\0';
> +
> +	(*subpart) = new_subpart;
> +	return 0;
> +fail:
> +	kfree(new_subpart);
> +	return ret;
> +}
> +
> +static void free_subpart(struct cmdline_parts *parts) {
> +	struct cmdline_subpart *subpart;
> +
> +	while (parts->subpart) {
> +		subpart = parts->subpart;
> +		parts->subpart = subpart->next_subpart;
> +		kfree(subpart);
> +	}
> +}
> +
> +static void free_parts(struct cmdline_parts **parts) {
> +	struct cmdline_parts *next_parts;
> +
> +	while ((*parts)) {
> +		next_parts = (*parts)->next_parts;
> +		free_subpart((*parts));
> +		kfree((*parts));
> +		(*parts) = next_parts;
> +	}
> +}
> +
> +static int parse_parts(struct cmdline_parts **parts, const char
> +*cmdline) {
> +	int ret = -EFAULT;

EINVAL?

> +	char *next;
> +	int length;
> +	struct cmdline_subpart **next_subpart;
> +	struct cmdline_parts *newparts;
> +	char buf[BDEVNAME_SIZE + 32 + 4];
> +
> +	(*parts) = NULL;
> +
> +	newparts = kzalloc(sizeof(struct cmdline_parts), GFP_KERNEL);
> +	if (!newparts)
> +		return -ENOMEM;
> +
> +	next = strchr(cmdline, ':');
> +	if (!next) {
> +		pr_warn("cmdline partition has not block device.");
> +		goto fail;
> +	}
> +
> +	length = min((int)(next - cmdline), (int)(sizeof(newparts->name) - 1));

Ditto.

> +	strncpy(newparts->name, cmdline, length);
> +	newparts->name[length] = '\0';
> +
> +	next_subpart = &newparts->subpart;
> +
> +	while (next && *(++next)) {
> +

Remove newline.

> +		cmdline = next;
> +		next = strchr(cmdline, ',');
> +
> +		length = (!next) ? (sizeof(buf) - 1) :
> +			min((int)(next - cmdline), (int)(sizeof(buf) - 1));

Sort the types out.

> +		strncpy(buf, cmdline, length);
> +		buf[length] = '\0';
> +
> +		ret = parse_subpart(next_subpart, buf);
> +		if (ret)
> +			goto fail;
> +
> +		next_subpart = &(*next_subpart)->next_subpart;
> +	}
> +
> +	if (!newparts->subpart) {
> +		pr_warn("cmdline partition has not valid partition.");
> +		goto fail;
> +	}
> +
> +	(*parts) = newparts;

The code adds these unneeded parentheses in several places.  They are
unneeded ;)

> +	return 0;
> +fail:
> +	free_subpart(newparts);
> +	kfree(newparts);
> +	return ret;
> +}
> +
> +static int parse_cmdline(struct cmdline_parts **parts, const char
> +*cmdline) {
> +	int ret;
> +	char *buf;
> +	char *pbuf;
> +	char *next;
> +	struct cmdline_parts **next_parts;
> +
> +	(*parts) = NULL;
> +
> +	next = pbuf = buf = kstrdup(cmdline, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	next_parts = parts;
> +
> +	while (next && *pbuf) {
> +

Remove newline.

> +		next = strchr(pbuf, ';');
> +		if (next)
> +			(*next) = '\0';
> +
> +		ret = parse_parts(next_parts, pbuf);
> +		if (ret)
> +			goto fail;
> +
> +		if (next)
> +			pbuf = ++next;
> +
> +		next_parts = &(*next_parts)->next_parts;
> +	}
> +
> +	if (!(*parts)) {
> +		pr_warn("cmdline partition has not valid partition.");
> +		ret = -EFAULT;
> +		goto fail;
> +	}
> +
> +	ret = 0;
> +done:
> +	kfree(buf);
> +	return ret;
> +
> +fail:
> +	free_parts(parts);
> +	goto done;
> +}
> +
> +/*
> + * Purpose: allocate cmdline partitions.
> + * Returns:
> + * -1 if unable to read the partition table
> + *  0 if this isn't our partition table
> + *  1 if successful
> + */
> +static int parse_partitions(struct parsed_partitions *state,
> +			    struct cmdline_parts *parts)
> +{
> +	int slot;
> +	uint64_t from = 0;
> +	uint64_t disk_size;
> +	char buf[BDEVNAME_SIZE];
> +	struct cmdline_subpart *subpart;
> +
> +	bdevname(state->bdev, buf);
> +
> +	while (parts && strncmp(buf, parts->name, BDEVNAME_SIZE))
> +		parts = parts->next_parts;
> +
> +	if (!parts)
> +		return 0;
> +
> +	disk_size = (uint64_t) get_capacity(state->bdev->bd_disk) << 9;

Remove the space after the cast.

get_capacity() returns sector_t.  That is appropriate.  It would be
saner if all this code were to use sector_t as well.

Also, u64 is preferred over uint64_t in kernel code.

> +	for (slot = 1, subpart = parts->subpart;
> +	     subpart && slot < state->limit;
> +	     subpart = subpart->next_subpart, slot++) {
> +

Remove newline.

> +		unsigned label_max;
> +		struct partition_meta_info *info;
> +
> +		if (subpart->from == OFFSET_CONTINUOUS)
> +			subpart->from = from;
> +		else
> +			from = subpart->from;
> +
> +		if (from >= disk_size)
> +			break;
> +
> +		if (subpart->size > (disk_size - from))
> +			subpart->size = disk_size - from;
> +
> +		from += subpart->size;
> +
> +		put_partition(state, slot, le64_to_cpu(subpart->from >> 9),
> +			      le64_to_cpu(subpart->size >> 9));
> +
> +		info = &state->parts[slot].info;
> +
> +		label_max = min(sizeof(info->volname) - 1,
> +			sizeof(subpart->name));
> +		strncpy(info->volname, subpart->name, label_max);
> +		info->volname[label_max] = '\0';
> +		state->parts[slot].has_info = true;
> +	}
> +
> +	strlcat(state->pp_buf, "\n", PAGE_SIZE);
> +
> +	return 1;
> +}
> +
> +static int set_cmdline_parts(char *str) {
> +	strncpy(cmdline_string, str, sizeof(cmdline_string) - 1);
> +	cmdline_string[sizeof(cmdline_string) - 1] = '\0';
> +	return 1;
> +}
> +__setup("cmdlineparts=", set_cmdline_parts);
> +
> +void cmdline_parts_setup(char *str)
> +{
> +	mutex_lock(&cmdline_string_mutex);
> +	set_cmdline_parts(str);
> +	mutex_unlock(&cmdline_string_mutex);
> +}
> +EXPORT_SYMBOL(cmdline_parts_setup);

This export is unneed, I expect.

cmdline_parts_setup has no references and can simply be removed?

> +/*
> + * Purpose: allocate cmdline partitions.
> + * Returns:
> + * -1 if unable to read the partition table
> + *  0 if this isn't our partition table
> + *  1 if successful
> + */
> +int cmdline_partition(struct parsed_partitions *state) {
> +	int ret;
> +
> +	mutex_lock(&cmdline_string_mutex);
> +	if (cmdline_string[0]) {
> +
> +		if (cmdline_parts)
> +			free_parts(&cmdline_parts);
> +
> +		if (parse_cmdline(&cmdline_parts, cmdline_string)) {
> +			ret = 0;
> +			goto fail;
> +		}
> +		cmdline_string[0] = '\0';
> +	}
> +	mutex_unlock(&cmdline_string_mutex);
> +
> +	if (!cmdline_parts)
> +		return 0;
> +
> +	return parse_partitions(state, cmdline_parts);

But we dropped the mutex.  Nothing protects cmdline_parts during the
execution of parse_partitions().

> +fail:
> +	cmdline_string[0] = '\0';
> +	mutex_unlock(&cmdline_string_mutex);
> +	return ret;
> +}
> diff --git a/block/partitions/cmdline.h b/block/partitions/cmdline.h new file mode 100644 index 0000000..26e0f8d
> --- /dev/null
> +++ b/block/partitions/cmdline.h
> @@ -0,0 +1,2 @@
> +
> +int cmdline_partition(struct parsed_partitions *state);
> --
> 1.8.1.5
