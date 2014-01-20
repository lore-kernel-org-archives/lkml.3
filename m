Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaATJz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:55:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbaATJz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:55:27 -0500
Message-ID: <1390211726.11931.10.camel@linux-fkkt.site>
Subject: Re: [PATCH v3] HID: New hid-cp2112 driver
From: Oliver Neukum <oneukum@suse.de>
To: David Barksdale <dbarksdale@uplogix.com>
Cc: David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jakub =?ISO-8859-1?Q?K=E1kona?= <kjakub@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 20 Jan 2014 10:55:26 +0100
In-Reply-To: <1389909144-11050-1-git-send-email-dbarksdale@uplogix.com>
References: <1389909144-11050-1-git-send-email-dbarksdale@uplogix.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 15:52 -0600, David Barksdale wrote:

> +enum {
> +	STATUS1_TIMEOUT_NACK = 0x00,
> +	STATUS1_TIMEOUT_BUS = 0x01,
> +	STATUS1_ARBITRATION_LOST = 0x02,
> +	STATUS1_READ_INCOMPLETE = 0x03,
> +	STATUS1_WRITE_INCOMPLETE = 0x04,
> +	STATUS1_SUCCESS = 0x05,
> +};
> +
> +/* All values are in big-endian */

We have data types like be32.

> +struct __attribute__ ((__packed__)) cp2112_smbus_config_report {
> +	uint8_t report; /* CP2112_SMBUS_CONFIG */
> +	uint32_t clock_speed; /* Hz */
> +	uint8_t device_address; /* Stored in the upper 7 bits */
> +	uint8_t auto_send_read; /* 1 = enabled, 0 = disabled */
> +	uint16_t write_timeout; /* ms, 0 = no timeout */
> +	uint16_t read_timeout; /* ms, 0 = no timeout */
> +	uint8_t scl_low_timeout; /* 1 = enabled, 0 = disabled */
> +	uint16_t retry_time; /* # of retries, 0 = no limit */
> +};
> +
> +struct  __attribute__ ((__packed__)) cp2112_usb_config_report {
> +	uint8_t report; /* CP2112_USB_CONFIG */
> +	uint16_t vid; /* Vendor ID - little endian */
> +	uint16_t pid; /* Product ID - little endian */
> +	uint8_t max_power; /* Power requested in 2mA units */
> +	uint8_t power_mode; /* 0x00 = bus powered
> +			       0x01 = self powered & regulator off
> +			       0x02 = self powered & regulator on */
> +	uint8_t release_major;
> +	uint8_t release_minor;
> +	uint8_t mask; /* What fields to program */
> +};
> +
> +/* Number of times to request transfer status before giving up waiting for a
> +   transfer to complete. */
> +static const int XFER_TIMEOUT = 100;
> +
> +/* Time in ms to wait for a CP2112_DATA_READ_RESPONSE or
> +   CP2112_TRANSFER_STATUS_RESPONSE. */
> +static const int RESPONSE_TIMEOUT = 50;
> +
> +static const struct hid_device_id cp2112_devices[] = {
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_CP2112) },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(hid, cp2112_devices);
> +
> +struct cp2112_device {
> +	struct i2c_adapter adap;
> +	struct hid_device *hdev;
> +	wait_queue_head_t wait;
> +	uint8_t read_data[61];
> +	uint8_t read_length;
> +	int xfer_status;
> +	atomic_t read_avail;
> +	atomic_t xfer_avail;
> +	struct gpio_chip gc;
> +};

> +static int cp2112_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct cp2112_device *dev = container_of(chip, struct cp2112_device,
> +						 gc);
> +	struct hid_device *hdev = dev->hdev;
> +	uint8_t buf[2];
> +	int ret;
> +
> +	ret = hdev->hid_get_raw_report(hdev, CP2112_GPIO_GET, buf,
> +				       sizeof (buf), HID_FEATURE_REPORT);
> +	if (ret != sizeof (buf)) {
> +		hid_err(hdev, "error requesting GPIO values: %d\n", ret);
> +		return ret;
> +	}
> +	return (buf[1] >> offset) & 1;

We do have a test_bit() primitive.

> +}


> +static int cp2112_read(struct cp2112_device *dev, uint8_t *data, size_t size)
> +{
> +	struct hid_device *hdev = dev->hdev;
> +	uint8_t buf[3];
> +	int ret;
> +
> +	buf[0] = CP2112_DATA_READ_FORCE_SEND;
> +	*(uint16_t *)&buf[1] = htons(size);

Ouch. Please use put_unaligned()

> +	atomic_set(&dev->read_avail, 0);
> +	ret = cp2112_hid_output(hdev, buf, 3, HID_OUTPUT_REPORT);
> +	if (ret < 0) {
> +		hid_warn(hdev, "Error requesting data: %d\n", ret);
> +		return ret;
> +	}
> +	ret = cp2112_wait(dev, &dev->read_avail);
> +	if (ret)
> +		return ret;
> +	hid_dbg(hdev, "read %d of %d bytes requested\n",
> +		dev->read_length, size);
> +	if (size > dev->read_length)
> +		size = dev->read_length;
> +	memcpy(data, dev->read_data, size);
> +	return dev->read_length;
> +}
> +

	Regards
		Oliver


