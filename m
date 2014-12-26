Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaLZM1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 07:27:09 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45131 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaLZM1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 07:27:05 -0500
Message-ID: <549D5416.9020001@kernel.org>
Date: Fri, 26 Dec 2014 12:27:02 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [PATCH v3 1/5] iio: common: ssp_sensors: Add sensorhub driver
References: <1417809290-9662-1-git-send-email-k.wrona@samsung.com> <1417809290-9662-2-git-send-email-k.wrona@samsung.com> <54830E09.2040102@kernel.org> <549006C2.4070505@samsung.com>
In-Reply-To: <549006C2.4070505@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/12/14 10:17, Karol Wrona wrote:
> On 12/06/2014 03:09 PM, Jonathan Cameron wrote:
>> On 05/12/14 19:54, Karol Wrona wrote:
>>> Sensorhub  is MCU dedicated to collect data and manage several sensors.
>>> Sensorhub is a spi device which provides a layer for IIO devices. It provides
>>> some data parsing and common mechanism for sensorhub sensors.
>>>
>>> Adds common sensorhub library for sensorhub driver and iio drivers
>>> which uses sensorhub MCU to communicate with sensors.
>>>
>>> Change-Id: I4f066e9f3f477d4f6faabd4507be98e32f79e344
>>> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Nice bit of code.  A few comments inline, mostly slight preferences rather
>> than anything else.  I wonder if it's worth centralising some of the buffers
>> to cut down on the large number of little allocations.
> I have some questions (inline).
<snip>
>>> +
>>> +/**
>>> + * ssp_disable_sensor() - disables sensor
>>> + *
>>> + * @data:	sensorhub structure
>>> + * @type:	SSP sensor type
>>> + *
>>> + * Returns 0 or negative value in case of error
>> Nice docs. Though why this rather obvious one gets docs and the less
>> obvious ones don't is an interesting question...
> Just because they are exported.
Hmm.  Nothing wrong with documenting things that aren't as well if it helps
with clarity ;)  
>>> + */
>>> +int ssp_disable_sensor(struct ssp_data *data, enum ssp_sensor_type type)
>>> +{
>>> +	int ret;
>>> +	__le32 command;
>>> +
>>> +	if (data->sensor_enable & BIT(type)) {
>>> +		command = cpu_to_le32(data->delay_buf[type]);
>>> +
>>> +		ret = ssp_send_instruction(data,
>>> +					   SSP_MSG2SSP_INST_BYPASS_SENSOR_RM,
>>> +					   type, (u8 *)&command,
>>> +					   sizeof(command));
>>> +		if (ret < 0) {
>>> +			dev_err(&data->spi->dev, "Remove sensor fail\n");
>>> +			return ret;
>>> +		}
>>> +
>>> +		data->sensor_enable &= ~BIT(type);
>>> +	}
>>> +
>>> +	data->check_status[type] = SSP_ADD_SENSOR_STATE;
>>> +
>>> +	if (atomic_dec_and_test(&data->enable_refcount))
>>> +		ssp_disable_wdt_timer(data);
>>> +
>>> +	return 0;
>>> +}
>>> +EXPORT_SYMBOL(ssp_disable_sensor);
>>> +
>>> +static irqreturn_t sensordata_irq_thread_fn(int irq, void *dev_id)
>>> +{
>>> +	struct ssp_data *data = dev_id;
>>> +
>>> +	ssp_irq_msg(data);
>> Why have this trivial wrapper instead of just having the code here?
>> Might make sense but please explain.
> I wanted to preserve error path for ssp_irq_msg and keep it in spi file.
Fair enough.
>>> +
>>> +	return IRQ_HANDLED;
>>> +}
>>> +
>>> +static int ssp_initialize_mcu(struct ssp_data *data)
>>> +{
>>> +	int ret;
>>> +
>>> +	ssp_clean_pending_list(data);
>>> +
>>> +	ret = ssp_get_chipid(data);
>>> +	if (ret != SSP_DEVICE_ID) {
>>> +		dev_err(&data->spi->dev, "%s - MCU %s ret = %d\n", __func__,
>>> +			ret < 0 ? "is not working" : "identification failed",
>>> +			ret);
>>> +		return ret < 0 ? ret : -ENODEV;
>>> +	}
>>> +
>>> +	dev_info(&data->spi->dev, "MCU device ID = %d\n", ret);
>>> +
>>> +	ret = ssp_set_sensor_position(data);
>>> +	if (ret < 0) {
>>> +		dev_err(&data->spi->dev, "ssp_set_sensor_position failed\n");
>>> +		return ret;
>>> +	}
>>> +
>>> +	ret = ssp_set_magnetic_matrix(data);
>> Hmm. It feels like this might belong more in the iio driver than here.
>> Please justify.
>>> +	if (ret < 0) {
>>> +		dev_err(&data->spi->dev,
>>> +			"%s - ssp_set_magnetic_matrix failed\n", __func__);
>>> +		return ret;
>>> +	}
>>> +
>>> +	data->available_sensors = ssp_get_sensor_scanning_info(data);
>>> +	if (data->available_sensors == 0) {
>>> +		dev_err(&data->spi->dev,
>>> +			"%s - ssp_get_sensor_scanning_info failed\n", __func__);
>>> +		return -EIO;
>>> +	}
>>> +
>>> +	data->cur_firm_rev = ssp_get_firmware_rev(data);
>>> +	dev_info(&data->spi->dev, "MCU Firm Rev : New = %8u\n",
>>> +		 data->cur_firm_rev);
>>> +
>>> +	return ssp_command(data, SSP_MSG2SSP_AP_MCU_DUMP_CHECK, 0);
>>> +}
>>> +
>> What's this doing?  Perhaps a bit of documentation to explain why a
>> task might want refreshing?
>>> +static void ssp_refresh_task(struct work_struct *work)
>>> +{
>>> +	struct ssp_data *data = container_of((struct delayed_work *)work,
>>> +					     struct ssp_data, work_refresh);
>>> +
>>> +	dev_info(&data->spi->dev, "refreshing\n");
>>> +
>>> +	data->reset_cnt++;
>>> +
>>> +	if (ssp_initialize_mcu(data) >= 0) {
>>> +		ssp_sync_available_sensors(data);
>>> +		if (data->last_ap_state != 0)
>>> +			ssp_command(data, data->last_ap_state, 0);
>>> +
>>> +		if (data->last_resume_state != 0)
>>> +			ssp_command(data, data->last_resume_state, 0);
>>> +
>>> +		data->timeout_cnt = 0;
>>> +		data->com_fail_cnt = 0;
>>> +	}
>>> +}
>>> +
>>> +
>>> +/**
>>> + * ssp_register_consumer() - registers iio consumer in ssp framework
>>> + *
>>> + * @indio_dev:	consumer iio device
>>> + * @type:	ssp sensor type
>>> + */
>>> +void ssp_register_consumer(struct iio_dev *indio_dev, enum ssp_sensor_type type)
>>> +{
>>> +	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
>> That's one uggly way to get to the ssp_data structure.  Perhaps we need
>> a few macros to make it obvious what we are jumping through?
> You mean something local like:
> #define SSP_GET_DEV_GRAMPA(iio_dev) (iio_dev->dev.parent->parent)
> or something in IIO:
> #define IIO_GET_DEV_PARENT(iio_dev) (iio_dev->dev.parent)
> ?
The first one, but now you type it out, that's not very nice either.
Perhaps better to leave it as it is.
>>
>>> +
>>> +	data->sensor_devs[type] = indio_dev;
>>> +}
>>> +EXPORT_SYMBOL(ssp_register_consumer);
>>> +
<snip>
>>> diff --git a/drivers/iio/common/ssp_sensors/ssp_spi.c b/drivers/iio/common/ssp_sensors/ssp_spi.c
>>> new file mode 100644
>>> index 0000000..44b99bc
>>> --- /dev/null
>>> +++ b/drivers/iio/common/ssp_sensors/ssp_spi.c
<snip>
>>> +
>>> +#define SSP_HEADER_SIZE		(sizeof(struct ssp_msg_header))
>>> +#define SSP_HEADER_SIZE_ALIGNED	(ALIGN(SSP_HEADER_SIZE, 4))
>>> +
>> It strikes me that you do a lot of allocating and freeing of the buffers
>> in here.  Whilst this is fine, perhaps preallocating space in your
>> ssp_data (making sure to enforce cache alignment) would be simpler
>> and quicker?  That is the common way to avoid allocating spi buffers
>> on every transaction.
> I think that for commands there is no pain with that because they are allocated
> not very frequently. Maybe in the future I could modify that I could have
> prealocated set of buffers but also there are some places where the frames can
> have different sized which will be know after header parsing.
> You are right in case of irq header and accessing sensor data in callback
> provided by sensors.
Cool
> 
>>
>> You could perhaps even roll the message header stuff etc into ssp_spi_sync?
>> (I haven't yet looked at that many call sites so that might not make sense!)
>> Would cut down on the boiler plate in the short functions towards the
>> end of this patch.
>>> +static struct ssp_msg *ssp_create_msg(u8 cmd, u16 len, u16 opt, u32 data)
>>> +{
>>> +	struct ssp_msg_header h;
>>> +	struct ssp_msg *msg;
>>> +
>>> +	msg = kzalloc(sizeof(*msg), GFP_KERNEL);
>>> +	if (!msg)
>>> +		return NULL;
>>> +
>>> +	h.cmd = cmd;
>>> +	h.length = cpu_to_le16(len);
>>> +	h.options = cpu_to_le16(opt);
>>> +	h.data = cpu_to_le32(data);
>>> +
>>> +	msg->buffer = kzalloc(SSP_HEADER_SIZE_ALIGNED + len,
>>> +			      GFP_KERNEL | GFP_DMA);
>>> +	if (!msg->buffer) {
>>> +		kfree(msg);
>>> +		return NULL;
>>> +	}
>>> +
>>> +	msg->length = len;
>>> +	msg->options = opt;
>>> +
>>> +	memcpy(msg->buffer, &h, SSP_HEADER_SIZE);
>>> +
>>> +	return msg;
>>> +}
>>> +
>>> +static inline void ssp_fill_buffer(struct ssp_msg *m, unsigned int offset,
>>> +				   const void *src, unsigned int len)
>>> +{
>>> +	memcpy(&m->buffer[SSP_HEADER_SIZE_ALIGNED + offset], src, len);
>>
>> These seem a little heavy handed. Could you do this by getting a pointer
>> to the appropriate location instead?  That way you'll often save on the
>> memory copies.  Not that they are that extensive.
>>
>>> +}
>>> +
>>> +static inline void ssp_get_buffer(struct ssp_msg *m, unsigned int offset,
>>> +				  void *dest, unsigned int len)
>>> +{
>>> +	memcpy(dest, &m->buffer[SSP_HEADER_SIZE_ALIGNED + offset],  len);
>>> +}
>>> +
>>> +#define ssp_get_buffer_AT_INDEX(m, index) \
>>> +	(m->buffer[SSP_HEADER_SIZE_ALIGNED + index])
>> Novel mixture of upper and lower case.  Please go with upper.
>>> +#define SSP_SET_BUFFER_AT_INDEX(m, index, val) \
>>> +	(m->buffer[SSP_HEADER_SIZE_ALIGNED + index] = val)
>>> +
>>> +static void ssp_clean_msg(struct ssp_msg *m)
>>> +{
>>> +	kfree(m->buffer);
>>> +	kfree(m);
>>> +}
>>> +
>>> +static int ssp_print_mcu_debug(char *data_frame, int *data_index,
>>> +			       int received_len)
>>> +{
>>> +	int length = data_frame[(*data_index)++];
>>> +
>>> +	if (length > received_len - *data_index || length <= 0) {
>>> +		ssp_dbg("[SSP]: MSG From MCU-invalid debug length(%d/%d)\n",
>>> +			length, received_len);
>>> +		return length ? length : -EPROTO;
>>> +	}
>>> +
>>> +	ssp_dbg("[SSP]: MSG From MCU - %s\n", &data_frame[*data_index]);
>>> +
>>> +	*data_index += length;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +/*
>>> + * It was designed that way - additional lines to some kind of handshake,
>>> + * please do not ask why - only the firmware guy can know it.
>> Indeed crazy.
>>> + */
>>> +static int ssp_check_lines(struct ssp_data *data, bool state)
>>> +{
>>> +	int delay_cnt = 0;
>>> +
>>> +	gpio_set_value_cansleep(data->ap_mcu_gpio, state);
>>> +
>>> +	while (gpio_get_value_cansleep(data->mcu_ap_gpio) != state) {
>>> +		usleep_range(3000, 3500);
>>> +
>>> +		if (data->shut_down || delay_cnt++ > 500) {
>>> +			dev_err(SSP_DEV, "%s:timeout, hw ack wait fail %d\n",
>>> +				__func__, state);
>>> +
>>> +			if (!state)
>>> +				gpio_set_value_cansleep(data->ap_mcu_gpio, 1);
>>> +
>>> +			return -ETIMEDOUT;
>>> +		}
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int ssp_do_transfer(struct ssp_data *data, struct ssp_msg *msg,
>>> +			   struct completion *done, int timeout)
>>> +{
>>> +	int status;
>>> +	/*
>>> +	 * check if this is a short one way message or the whole transfer has
>>> +	 * second part after an interrupt
>>> +	 */
>>> +	const bool use_no_irq = msg->length == 0;
>>
>> I wonder if you'd be better off having a separate short_write function.
>> Might take a line or two more code, but would make it a little clearer
>> what is going on and simplify the code flow in this function a fair bit.
>>
>>> +
>>> +	if (data->shut_down)
>>> +		return -EPERM;
>>> +
>>> +	msg->done = done;
>>> +
>>> +	mutex_lock(&data->comm_lock);
>>> +
>>> +	status = ssp_check_lines(data, false);
>>> +	if (status < 0)
>>> +		goto _error_locked;
>>> +
>>> +	status = spi_write(data->spi, msg->buffer, SSP_HEADER_SIZE);
>>> +	if (status < 0) {
>>> +		gpio_set_value_cansleep(data->ap_mcu_gpio, 1);
>>> +		dev_err(SSP_DEV, "%s spi_write fail\n", __func__);
>>> +		goto _error_locked;
>>> +	}
>>> +
>>> +	if (!use_no_irq) {
>>> +		mutex_lock(&data->pending_lock);
>>> +		list_add_tail(&msg->list, &data->pending_list);
>>> +		mutex_unlock(&data->pending_lock);
>>> +	}
>>> +
>>> +	status = ssp_check_lines(data, true);
>>> +	if (status < 0) {
>>> +		if (!use_no_irq) {
>>> +			mutex_lock(&data->pending_lock);
>>> +			list_del(&msg->list);
>>> +			mutex_unlock(&data->pending_lock);
>>> +		}
>>> +		goto _error_locked;
>>> +	}
>>> +
>>> +	mutex_unlock(&data->comm_lock);
>>> +
>>> +	if (!use_no_irq && done)
>>> +		if (wait_for_completion_timeout(done,
>>> +						msecs_to_jiffies(timeout)) ==
>>> +		    0) {
>>> +			mutex_lock(&data->pending_lock);
>>> +			list_del(&msg->list);
>>> +			mutex_unlock(&data->pending_lock);
>>> +
>>> +			data->timeout_cnt++;
>>> +			return -ETIMEDOUT;
>>> +		}
>>> +
>>> +	return 0;
>>> +
>>> +_error_locked:
>>> +	mutex_unlock(&data->comm_lock);
>>> +	data->timeout_cnt++;
>>> +	return status;
>>> +}
>>> +
>>> +static inline int ssp_spi_sync_command(struct ssp_data *data,
>>> +				       struct ssp_msg *msg)
>>> +{
>>> +	return ssp_do_transfer(data, msg, NULL, 0);
>>> +}
>>> +
<snip>

>>> +		case SSP_MSG2AP_INST_LIBRARY_DATA:
>>> +			idx += len;
>> That looks fun.  What the heck is library data?  Just curious ;)
> It is a mock-up only.  I left this in case of such frame but it shoud not happen
> because the driver do not handle this yet.  I will fix it because it is wrong
> (offset). While adding composite sensors I would like to add descriptive names.
> You are right that it looks stupid..
Not quite what I meant. I just wondered what Library data would be when added
properly?  Curiosity, nothing more ;)
> 
>>> +			break;
>>> +		case SSP_MSG2AP_INST_BIG_DATA:
>>> +			ssp_handle_big_data(data, dataframe, &idx);
>>> +			break;
>>> +		case SSP_MSG2AP_INST_TIME_SYNC:
>>> +			data->time_syncing = true;
>>> +			break;
>>> +		case SSP_MSG2AP_INST_RESET:
>>> +			ssp_queue_ssp_refresh_task(data, 0);
>>> +			break;
>>> +		}
>>> +	}
>>> +
>>> +	if (data->time_syncing)
>>> +		data->timestamp = ts.tv_sec * 1000000000ULL + ts.tv_nsec;
>>> +
>>> +	return 0;
>>> +}
>>> +
<snip>

