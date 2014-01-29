Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaA2XqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 18:46:12 -0500
Received: from smtprelay0083.hostedemail.com ([216.40.44.83]:37731 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751126AbaA2XqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 18:46:10 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:2196:2199:2376:2393:2559:2562:2828:2898:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:4321:4385:4605:5007:6119:7652:8603:10004:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13161:13229:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: part81_185ccb93b3829
X-Filterd-Recvd-Size: 5876
Message-ID: <1391039165.2422.11.camel@joe-AO722>
Subject: Re: [PATCH v4] HID: New hid-cp2112 driver
From: Joe Perches <joe@perches.com>
To: David Barksdale <dbarksdale@uplogix.com>
Cc: David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Oliver Neukum <oliver@neukum.org>,
        Jakub =?ISO-8859-1?Q?K=E1kona?= <kjakub@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 15:46:05 -0800
In-Reply-To: <1391037975-26253-1-git-send-email-dbarksdale@uplogix.com>
References: <1391037975-26253-1-git-send-email-dbarksdale@uplogix.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-29 at 17:26 -0600, David Barksdale wrote:
> This patch adds support for the Silicon Labs CP2112
> "Single-Chip HID USB to SMBus Master Bridge."

Just some trivial notes:

> diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
[]
> +struct __attribute__ ((__packed__)) cp2112_smbus_config_report {

Please use

struct name {
	...
} __packed;

This allows a simpler grep pattern to find the
struct definition.  There are many of these.

[]

> +static int cp2112_hid_get(struct hid_device *hdev, unsigned char report_number,
> +			  u8 *data, size_t count, unsigned char report_type)
> +{
> +	u8 *buf;
> +	int ret;
> +
> +	buf = kmalloc(count, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	ret = hdev->hid_get_raw_report(hdev, report_number, buf, count,
> +				       report_type);
> +	memcpy(data, buf, count);
> +	kfree(buf);
> +	return ret;

if the data is going to be copied in data,
why not just use data in hid_get_raw_report
and avoid the malloc?

> +static int cp2112_hid_output(struct hid_device *hdev, u8 *data, size_t count,
> +			     unsigned char report_type)
> +{
> +	u8 *buf;
> +	int ret;
> +
> +	buf = kmemdup(data, count, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	ret = hdev->hid_output_raw_report(hdev, buf, count, report_type);
> +	kfree(buf);
> +	return ret;

same question.

> +static int cp2112_xfer(struct i2c_adapter *adap, u16 addr,
> +		       unsigned short flags, char read_write, u8 command,
> +		       int size, union i2c_smbus_data *data)
> +{
> +	struct cp2112_device *dev = (struct cp2112_device *)adap->algo_data;
> +	struct hid_device *hdev = dev->hdev;
> +	u8 buf[64];
> +	__be16 word;
> +	size_t count;
> +	size_t read_length = 0;
> +	size_t timeout;

size_t is an odd type for a variable named timeout

[]

> +	for (timeout = 0; timeout < XFER_TIMEOUT; ++timeout) {
> +		ret = cp2112_xfer_status(dev);
> +		if (-EBUSY == ret)
> +			continue;
> +		if (ret < 0)
> +			goto power_normal;
> +		break;
> +	}

and it looks more like an maximum attempt count
than a timeout.

> +
> +	if (XFER_TIMEOUT <= timeout) {
> +		hid_warn(hdev, "Transfer timed out, cancelling.\n");
> +		buf[0] = CP2112_CANCEL_TRANSFER;
> +		buf[1] = 0x01;

[]

> +#define CP2112_CONFIG_ATTR(name, store, format, ...) \
> +static ssize_t name##_store(struct device *kdev, \
> +			    struct device_attribute *attr, const char *buf, \
> +			    size_t count) \
> +{ \
> +	struct hid_device *hdev = container_of(kdev, struct hid_device, dev); \
> +	struct cp2112_usb_config_report cfg; \
> +	int ret = cp2112_get_usb_config(hdev, &cfg); \
> +	if (ret) \
> +		return ret; \
> +	store; \
> +	ret = cp2112_set_usb_config(hdev, &cfg); \
> +	if (ret) \
> +		return ret; \
> +	chmod_sysfs_attrs(hdev); \
> +	return count; \
> +} \
> +static ssize_t name##_show(struct device *kdev, \
> +			   struct device_attribute *attr, char *buf) \
> +{ \
> +	struct hid_device *hdev = container_of(kdev, struct hid_device, dev); \
> +	struct cp2112_usb_config_report cfg; \
> +	int ret = cp2112_get_usb_config(hdev, &cfg); \
> +	if (ret) \
> +		return ret; \
> +	return scnprintf(buf, PAGE_SIZE, format, __VA_ARGS__); \

##__VA_ARGS__ would probably be better


> +} \
> +DEVICE_ATTR_RW(name);
> +
> +CP2112_CONFIG_ATTR(vendor_id, ({
> +	u16 vid;
> +
> +	if (sscanf(buf, "%hi", &vid) != 1)
> +		return -EINVAL;
> +
> +	cfg.vid = cpu_to_le16(vid);
> +	cfg.mask = 0x01;
> +}), "0x%04x\n", le16_to_cpu(cfg.vid));
> +
> +CP2112_CONFIG_ATTR(product_id, ({
> +	u16 pid;
> +
> +	if (sscanf(buf, "%hi", &pid) != 1)
> +		return -EINVAL;
> +
> +	cfg.pid = cpu_to_le16(pid);
> +	cfg.mask = 0x02;
> +}), "0x%04x\n", le16_to_cpu(cfg.pid));

These uses of CP2112_CONFIG_ATTR are kind of ugly.

> +
> +CP2112_CONFIG_ATTR(max_power, ({
> +	int mA;
> +
> +	if (sscanf(buf, "%i", &mA) != 1)
> +		return -EINVAL;
> +
> +	cfg.max_power = (mA + 1) / 2;
> +	cfg.mask = 0x04;
> +}), "%u mA\n", cfg.max_power * 2);
> +
> +CP2112_CONFIG_ATTR(power_mode, ({
> +	if (sscanf(buf, "%hhi", &cfg.power_mode) != 1)
> +		return -EINVAL;
> +
> +	cfg.mask = 0x08;
> +}), "%u\n", cfg.power_mode);
> +
> +CP2112_CONFIG_ATTR(release_version, ({
> +	if (sscanf(buf, "%hhi.%hhi", &cfg.release_major, &cfg.release_minor)
> +	    != 2)
> +		return -EINVAL;
> +
> +	cfg.mask = 0x10;
> +}), "%u.%u\n", cfg.release_major, cfg.release_minor);

[]

> +static int cp2112_raw_event(struct hid_device *hdev, struct hid_report *report,
> +			    u8 *data, int size)
> +{
[]
> +		case STATUS0_ERROR:
> +			switch (xfer->status1) {
> +			case STATUS1_TIMEOUT_NACK:
> +			case STATUS1_TIMEOUT_BUS:
> +				dev->xfer_status = -ETIMEDOUT;
> +				break;
> +			default:
> +				dev->xfer_status = -EIO;

nicer with a break


