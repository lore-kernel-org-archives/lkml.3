Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbbAKRvM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 12:51:12 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:37631 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbbAKRvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 12:51:07 -0500
Message-ID: <54B2B804.70400@kernel.org>
Date: Sun, 11 Jan 2015 17:51:00 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Tirdea, Irina" <irina.tirdea@intel.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dogaru, Vlad" <vlad.dogaru@intel.com>,
        "Baluta, Daniel" <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [PATCH 8/8] iio: add driver for Freescale MMA9553
References: <1419029879-12024-1-git-send-email-irina.tirdea@intel.com> <1419029879-12024-9-git-send-email-irina.tirdea@intel.com> <54A5365A.8040406@kernel.org> <1F3AC3675D538145B1661F571FE1805F199FDE3C@irsmsx105.ger.corp.intel.com>
In-Reply-To: <1F3AC3675D538145B1661F571FE1805F199FDE3C@irsmsx105.ger.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/15 15:10, Tirdea, Irina wrote:
> 
> 
>> -----Original Message-----
>> From: Jonathan Cameron [mailto:jic23@kernel.org]
>> Sent: 01 January, 2015 13:58
>> To: Tirdea, Irina; linux-iio@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org; Dogaru, Vlad; Baluta, Daniel; Hartmut Knaack; Lars-Peter Clausen; Peter Meerwald
>> Subject: Re: [PATCH 8/8] iio: add driver for Freescale MMA9553
>>
>> On 19/12/14 22:57, Irina Tirdea wrote:
>>> Add support for Freescale MMA9553L Intelligent Pedometer Platform.
>>>
>>> The following functionalities are supported:
>>>  - step counter (counts the number of steps using a HW register)
>>>  - step detector (generates an iio event at every step the user takes)
>>>  - activity recognition (rest, walking, jogging, running)
>>>  - speed
>>>  - calories
>>>  - distance
>>>
>>> To get accurate pedometer results, the user's height, weight and gender
>>> need to be configured.
>>>
>>> The specifications can be downloaded from:
>>> http://www.freescale.com/files/sensors/doc/ref_manual/MMA955xLSWRM.pdf
>>> http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf
>>>
>>> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
>> A few bits an bobs beyond the interface discussions in the earlier patches
>> in the series.
>>
>> A nice looking driver on the whole, for a complex little device ;)
> 
> Thanks for the detailed review, Jonathan!
> 
<snip>
>>> +			mutex_unlock(&data->mutex);
>>> +			return ret;
>>> +		default:
>>> +			return -EINVAL;
>>> +		}
>>> +	case IIO_EV_INFO_PERIOD:
>>> +		switch (chan->type) {
>>> +		case IIO_STEPS:
>>> +			if (val < 0 || val > 255)
>>> +				return -EINVAL;
>>> +			mutex_lock(&data->mutex);
>>> +			ret = mma9553_set_config(data, MMA9553_CONF_SPEED_STEP,
>>> +						 &data->conf.speed_step, val,
>>> +						 MMA9553_CONF_STEPCOALESCE);
>> So this makes it fire every N steps?  Kind of nice, but not quite what period
>> is usually used for.  We have talked about having an absolute change
>> (rather than ROC) event type before - (requires a change of N and doesn't care
>> how long it took to happen).  Perhaps that makes sense here rather than
>> an instance event and a period?
> Considering the stepcoalesce option, a change event does make more
> sense. I will add IIO_CHANGE and use it instead.
> 
> Adding IIO_CHANGE event type will make IIO_INSTANCE redundant (since
> instance is change with a value of 1). I know once an interface is
> introduced it cannot be changed, but since nobody is using
> IIO_INSTANCE could we remove it?
Drop it and don't worry about.  ABI changes are only a problem if anyone
notices :)

>>
>>> +			mutex_unlock(&data->mutex);
>>> +			return ret;
>>> +		default:
>>> +			return -EINVAL;
>>> +		}
>>> +	default:
>>> +		return -EINVAL;
>>> +	}
>>> +}
>>> +
>>> +static const struct iio_event_spec mma9553_step_event = {
>>> +	.type = IIO_EV_TYPE_INSTANCE,
>>> +	.dir = IIO_EV_DIR_NONE,
>>> +	.mask_separate = BIT(IIO_EV_INFO_ENABLE) | BIT(IIO_EV_INFO_PERIOD),
>>> +};
>>> +
>>> +static const struct iio_event_spec mma9553_activity_events[] = {
>>> +	{
>>> +		.type = IIO_EV_TYPE_THRESH,
>>> +		.dir = IIO_EV_DIR_RISING,
>>> +		.mask_separate = BIT(IIO_EV_INFO_ENABLE) |
>>> +				 BIT(IIO_EV_INFO_VALUE),
>>> +	 },
>>> +	{
>>> +		.type = IIO_EV_TYPE_THRESH,
>>> +		.dir = IIO_EV_DIR_FALLING,
>>> +		.mask_separate = BIT(IIO_EV_INFO_ENABLE) |
>>> +				 BIT(IIO_EV_INFO_VALUE),
>>> +	},
>>> +};
>>> +
>>> +#define MMA9553_PEDOMETER_CHANNEL(_type, _mask) {		\
>>> +	.type = _type,						\
>>> +	.info_mask_separate = BIT(IIO_CHAN_INFO_ENABLE)      |	\
>>> +			      BIT(IIO_CHAN_INFO_CALIBHEIGHT) |	\
>>> +			      BIT(IIO_CHAN_INFO_CALIBGENDER) |	\
>>> +			      _mask,				\
>>> +}
>>> +
>>> +#define MMA9553_ACTIVITY_CHANNEL(_chan2) {				\
>>> +	.type = IIO_ACTIVITY,						\
>>> +	.modified = 1,							\
>>> +	.channel2 = _chan2,						\
>>> +	.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),		\
>>> +	.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_CALIBHEIGHT) |	\
>>> +				    BIT(IIO_CHAN_INFO_CALIBGENDER),	\
>>> +	.event_spec = mma9553_activity_events,				\
>>> +	.num_event_specs = ARRAY_SIZE(mma9553_activity_events),		\
>>> +}
>>> +
>>> +static const struct iio_chan_spec mma9553_channels[] = {
>>> +	MMA9551_ACCEL_CHANNEL(IIO_MOD_X),
>>> +	MMA9551_ACCEL_CHANNEL(IIO_MOD_Y),
>>> +	MMA9551_ACCEL_CHANNEL(IIO_MOD_Z),
>>> +
>>> +	{
>>> +		.type = IIO_STEPS,
>>> +		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED) |
>>> +				      BIT(IIO_CHAN_INFO_ENABLE) |
>>> +				      BIT(IIO_CHAN_INFO_OFFSET) |
>>> +				      BIT(IIO_CHAN_INFO_INT_TIME),
>>> +		.event_spec = &mma9553_step_event,
>>> +		.num_event_specs = 1,
>>> +	},
>>> +
>>> +	MMA9553_PEDOMETER_CHANNEL(IIO_DISTANCE, BIT(IIO_CHAN_INFO_PROCESSED)),
>>> +	MMA9553_PEDOMETER_CHANNEL(IIO_SPEED, BIT(IIO_CHAN_INFO_RAW) |
>>> +				  BIT(IIO_CHAN_INFO_SCALE) |
>>> +				  BIT(IIO_CHAN_INFO_INT_TIME)),
>>> +	MMA9553_PEDOMETER_CHANNEL(IIO_CALORIES, BIT(IIO_CHAN_INFO_RAW) |
>>> +				  BIT(IIO_CHAN_INFO_SCALE) |
>>> +				  BIT(IIO_CHAN_INFO_CALIBWEIGHT)),
>>> +
>>> +	MMA9553_ACTIVITY_CHANNEL(IIO_MOD_RUNNING),
>>> +	MMA9553_ACTIVITY_CHANNEL(IIO_MOD_JOGGING),
>>> +	MMA9553_ACTIVITY_CHANNEL(IIO_MOD_WALKING),
>>> +	MMA9553_ACTIVITY_CHANNEL(IIO_MOD_STILL),
>>> +};
>>> +
>>> +static const struct iio_info mma9553_info = {
>>> +	.driver_module = THIS_MODULE,
>>> +	.read_raw = mma9553_read_raw,
>>> +	.write_raw = mma9553_write_raw,
>>> +	.read_event_config = mma9553_read_event_config,
>>> +	.write_event_config = mma9553_write_event_config,
>>> +	.read_event_value = mma9553_read_event_value,
>>> +	.write_event_value = mma9553_write_event_value,
>>> +};
>>> +
>> Only one copy of this?  We don't want to prevent people having more
>> than one of these devices attached to a given machine.
>> Hence by all means have a default version of this but then
>> clone it into the mma9553_data structure for manipulation.
>> Or have a mached array of booleans in there (same indexes)
>> to use for the "enabled"s.
>>
> Will fix this.
> 
>>> +static struct mma9553_event mma9553_events[] = {
>>> +	{
>>> +		.type = IIO_STEPS,
>>> +		.mod = IIO_NO_MOD,
>>> +		.dir = IIO_EV_DIR_NONE,
>>> +		.enabled = false,
>>> +	},
>>> +	{
>>> +		.type = IIO_ACTIVITY,
>>> +		.mod = IIO_MOD_STILL,
>>> +		.dir = IIO_EV_DIR_RISING,
>>> +		.enabled = false,
>>> +	},
>>> +	{
>>> +		.type = IIO_ACTIVITY,
>>> +		.mod = IIO_MOD_STILL,
>>> +		.dir = IIO_EV_DIR_FALLING,
>>> +		.enabled = false,
>>> +	},
>>> +	{
>>> +		.type = IIO_ACTIVITY,
>>> +		.mod = IIO_MOD_WALKING,
>>> +		.dir = IIO_EV_DIR_RISING,
>>> +		.enabled = false,
>>> +	},
>>> +	{
>>> +		.type = IIO_ACTIVITY,
>>> +		.mod = IIO_MOD_WALKING,
>>> +		.dir = IIO_EV_DIR_FALLING,
>>> +		.enabled = false,
>>> +	},
>>> +	{
>>> +		.type = IIO_ACTIVITY,
>>> +		.mod = IIO_MOD_JOGGING,
>>> +		.dir = IIO_EV_DIR_RISING,
>>> +		.enabled = false,
>>> +	},
>>> +	{
>>> +		.type = IIO_ACTIVITY,
>>> +		.mod = IIO_MOD_JOGGING,
>>> +		.dir = IIO_EV_DIR_FALLING,
>>> +		.enabled = false,
>>> +	},
>>> +	{
>>> +		.type = IIO_ACTIVITY,
>>> +		.mod = IIO_MOD_RUNNING,
>>> +		.dir = IIO_EV_DIR_RISING,
>>> +		.enabled = false,
>>> +	},
>>> +	{
>>> +		.type = IIO_ACTIVITY,
>>> +		.mod = IIO_MOD_RUNNING,
>>> +		.dir = IIO_EV_DIR_FALLING,
>>> +		.enabled = false,
>>> +	},
>>> +};
>>> +
>>> +static irqreturn_t mma9553_irq_handler(int irq, void *private)
>>> +{
>>> +	/*
>>> +	 * Since we only configure the interrupt pin when an
>>> +	 * event is enabled, we are sure we have at least
>>> +	 * one event enabled at this point.
>>> +	 */
>> IIRC simply not supplyling the top half handler has the same effect as
>> this (though then you don't have anywhere to put the comment!)
>> Actually - I'd be tempted to grab and stash a timestamp in here to
>> increase the precision of you step timing etc.
> Initially I used a NULL pointer instead of mma9553_irq_handler in devm_request_threaded_irq, but the registration failed with "Threaded irq requested with handler=NULL and !ONESHOT".
> However, it is better to grab the timestamp anyway so I will do that here.
> 
>>> +	return IRQ_WAKE_THREAD;
>>> +}
>>> +
>>> +static irqreturn_t mma9553_event_handler(int irq, void *private)
>>> +{
>>> +	struct iio_dev *indio_dev = private;
>>> +	struct mma9553_data *data = iio_priv(indio_dev);
>>> +	u16 stepcnt;
>>> +	u8 activity;
>>> +	struct mma9553_event *ev_activity, *ev_prev_activity, *ev_step_detect;
>>> +	int ret;
>>> +
>>> +	mutex_lock(&data->mutex);
>>> +	ret = mma9553_read_activity_stepcnt(data, &activity, &stepcnt);
>>> +	if (ret < 0) {
>>> +		mutex_unlock(&data->mutex);
>>> +		return IRQ_HANDLED;
>>> +	}
>>> +
>>> +	ev_prev_activity =
>>> +	    mma9553_get_event(data, IIO_ACTIVITY,
>>> +			      mma9553_activity_to_mod(data->activity),
>>> +			      IIO_EV_DIR_FALLING);
>>> +	ev_activity =
>>> +	    mma9553_get_event(data, IIO_ACTIVITY,
>>> +			      mma9553_activity_to_mod(activity),
>>> +			      IIO_EV_DIR_RISING);
>>> +	ev_step_detect =
>>> +	    mma9553_get_event(data, IIO_STEPS, IIO_NO_MOD, IIO_EV_DIR_NONE);
>>> +
>>> +	if (ev_step_detect->enabled && (stepcnt != data->stepcnt)) {
>>> +		data->stepcnt = stepcnt;
>>> +		iio_push_event(indio_dev,
>>> +			       IIO_EVENT_CODE(IIO_STEPS, 0, IIO_NO_MOD,
>>> +			       IIO_EV_DIR_NONE, IIO_EV_TYPE_INSTANCE, 0, 0, 0),
>>> +			       iio_get_time_ns());
>> Worth grabbing the timestamp earlier than this for precision reasons?
>>> +	}
>>> +
>>> +	if (activity != data->activity) {
>>> +		data->activity = activity;
>>> +		/* ev_activity can be NULL if activity == ACTIVITY_UNKNOWN */
>>> +		if (ev_prev_activity && ev_prev_activity->enabled)
>>> +			iio_push_event(indio_dev,
>>> +				       IIO_EVENT_CODE(IIO_ACTIVITY, 0,
>>> +				       ev_prev_activity->mod,
>>> +				       IIO_EV_DIR_FALLING,
>>> +				       IIO_EV_TYPE_THRESH, 0, 0, 0),
>>> +				       iio_get_time_ns());
>>> +
>>> +		if (ev_activity && ev_activity->enabled)
>>> +			iio_push_event(indio_dev,
>>> +				       IIO_EVENT_CODE(IIO_ACTIVITY, 0,
>>> +				       ev_activity->mod,
>>> +				       IIO_EV_DIR_RISING,
>>> +				       IIO_EV_TYPE_THRESH, 0, 0, 0),
>>> +				       iio_get_time_ns());
>>> +	}
>>> +	mutex_unlock(&data->mutex);
>>> +	return IRQ_HANDLED;
>>> +}
>>> +
>>> +static int mma9553_gpio_probe(struct i2c_client *client)
>>> +{
>>> +	struct device *dev;
>>> +	struct gpio_desc *gpio;
>>> +	int ret;
>>> +
>>> +	if (!client)
>>> +		return -EINVAL;
>>> +
>>> +	dev = &client->dev;
>>> +
>>> +	/* data ready gpio interrupt pin */
>>> +	gpio = devm_gpiod_get_index(dev, MMA9553_GPIO_NAME, 0);
>>> +	if (IS_ERR(gpio)) {
>>> +		dev_err(dev, "acpi gpio get index failed\n");
>>> +		return PTR_ERR(gpio);
>>> +	}
>>> +
>>> +	ret = gpiod_direction_input(gpio);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	ret = gpiod_to_irq(gpio);
>>> +
>>> +	dev_dbg(dev, "gpio resource, no:%d irq:%d\n", desc_to_gpio(gpio), ret);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +static const char *mma9553_match_acpi_device(struct device *dev)
>>> +{
>>> +	const struct acpi_device_id *id;
>>> +
>>> +	id = acpi_match_device(dev->driver->acpi_match_table, dev);
>>> +	if (!id)
>>> +		return NULL;
>>> +
>>> +	return dev_name(dev);
>>> +}
>>> +
>>> +static int mma9553_probe(struct i2c_client *client,
>>> +			 const struct i2c_device_id *id)
>>> +{
>>> +	struct mma9553_data *data;
>>> +	struct iio_dev *indio_dev;
>>> +	const char *name = NULL;
>>> +	int ret;
>>> +
>>> +	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
>>> +	if (!indio_dev)
>>> +		return -ENOMEM;
>>> +
>>> +	data = iio_priv(indio_dev);
>>> +	i2c_set_clientdata(client, indio_dev);
>>> +	data->client = client;
>>> +
>>> +	if (id)
>>> +		name = id->name;
>>> +	else if (ACPI_HANDLE(&client->dev))
>>> +		name = mma9553_match_acpi_device(&client->dev);
>>> +	else
>> Interesting to note the original driver doesn't have this else.  Worth
>> checking?
> There was a similar check in the initial driver (it checked for name == NULL instead) that somehow got removed in a later version.
> I could add the check in mma9551 as well, but I am not sure on what is the proper way to handle this.
> There is an ongoing discussion on this: http://www.spinics.net/lists/linux-iio/msg16231.html.
> I would rather for this to be cleared out and send a separate patch to fix both drivers if needed.
> 
>>> +		return -ENOSYS;
>>> +
>>> +	mutex_init(&data->mutex);
>>> +	data->events = mma9553_events;
>>> +	data->num_events = ARRAY_SIZE(mma9553_events);
>>> +
>>> +	ret = mma9553_init(data);
>>> +	if (ret < 0)
>>> +		return ret;
>>> +
>>> +	indio_dev->dev.parent = &client->dev;
>>> +	indio_dev->channels = mma9553_channels;
>>> +	indio_dev->num_channels = ARRAY_SIZE(mma9553_channels);
>>> +	indio_dev->name = name;
>>> +	indio_dev->modes = INDIO_DIRECT_MODE;
>>> +	indio_dev->info = &mma9553_info;
>>> +
>>> +	if (client->irq < 0)
>>> +		client->irq = mma9553_gpio_probe(client);
>>> +
>> So this time we just have a single irq.  That makes life simpler!
> Yes, mma9553 provides the option to combine all its interrupts in one status bit (while mma9551 does not).
> 
>>> +	if (client->irq >= 0) {
>>> +		ret = devm_request_threaded_irq(&client->dev, client->irq,
>>> +						mma9553_irq_handler,
>>> +						mma9553_event_handler,
>>> +						IRQF_TRIGGER_RISING,
>>> +						MMA9553_IRQ_NAME, indio_dev);
>>> +		if (ret < 0) {
>>> +			dev_err(&client->dev, "request irq %d failed\n",
>>> +				client->irq);
>>> +			goto out_poweroff;
>>> +		}
>>> +
>>> +	}
>>> +
>>> +	ret = iio_device_register(indio_dev);
>>> +	if (ret < 0) {
>>> +		dev_err(&client->dev, "unable to register iio device\n");
>>> +		goto out_poweroff;
>>> +	}
>>> +
>>> +	ret = pm_runtime_set_active(&client->dev);
>>> +	if (ret < 0)
>>> +		goto out_iio_unregister;
>>> +
>>> +	pm_runtime_enable(&client->dev);
>>> +	pm_runtime_set_autosuspend_delay(&client->dev,
>>> +					 MMA9551_AUTO_SUSPEND_DELAY_MS);
>>> +	pm_runtime_use_autosuspend(&client->dev);
>>> +
>>> +	dev_dbg(&indio_dev->dev, "Registered device %s\n", name);
>>> +	return 0;
>>> +
>>> +out_iio_unregister:
>>> +	iio_device_unregister(indio_dev);
>>> +out_poweroff:
>>> +	mma9551_set_device_state(client, false);
>>> +	return ret;
>>> +}
>>> +
>>> +static int mma9553_remove(struct i2c_client *client)
>>> +{
>>> +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
>>> +	struct mma9553_data *data = iio_priv(indio_dev);
>>> +
>>> +	pm_runtime_disable(&client->dev);
>>> +	pm_runtime_set_suspended(&client->dev);
>>> +	pm_runtime_put_noidle(&client->dev);
>>> +
>>> +	iio_device_unregister(indio_dev);
>>> +	mutex_lock(&data->mutex);
>>> +	mma9551_set_device_state(data->client, false);
>>> +	mutex_unlock(&data->mutex);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +#ifdef CONFIG_PM
>>> +static int mma9553_runtime_suspend(struct device *dev)
>>> +{
>>> +	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
>>> +	struct mma9553_data *data = iio_priv(indio_dev);
>>> +	int ret;
>>> +
>>> +	mutex_lock(&data->mutex);
>>> +	ret = mma9551_set_device_state(data->client, false);
>>> +	mutex_unlock(&data->mutex);
>>> +	if (ret < 0) {
>>> +		dev_err(&data->client->dev, "powering off device failed\n");
>>> +		return -EAGAIN;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int mma9553_runtime_resume(struct device *dev)
>>> +{
>>> +	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
>>> +	struct mma9553_data *data = iio_priv(indio_dev);
>>> +	int ret;
>>> +
>>> +	ret = mma9551_set_device_state(data->client, true);
>>> +	if (ret < 0)
>>> +		return ret;
>>> +
>>> +	mma9551_sleep(MMA9553_DEFAULT_SAMPLE_RATE);
>>> +	return 0;
>>> +}
>>> +#endif
>>> +
>>> +#ifdef CONFIG_PM_SLEEP
>>> +static int mma9553_suspend(struct device *dev)
>>> +{
>>> +	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
>>> +	struct mma9553_data *data = iio_priv(indio_dev);
>>> +	int ret;
>>> +
>>> +	mutex_lock(&data->mutex);
>>> +	ret = mma9551_set_device_state(data->client, false);
>>> +	mutex_unlock(&data->mutex);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +static int mma9553_resume(struct device *dev)
>>> +{
>>> +	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
>>> +	struct mma9553_data *data = iio_priv(indio_dev);
>>> +	int ret;
>>> +
>>> +	mutex_lock(&data->mutex);
>>> +	ret = mma9551_set_device_state(data->client, true);
>>> +	mutex_unlock(&data->mutex);
>>> +
>>> +	return ret;
>>> +}
>>> +#endif
>>> +
>>> +static const struct dev_pm_ops mma9553_pm_ops = {
>>> +	SET_SYSTEM_SLEEP_PM_OPS(mma9553_suspend, mma9553_resume)
>>> +	SET_RUNTIME_PM_OPS(mma9553_runtime_suspend,
>>> +			   mma9553_runtime_resume, NULL)
>>> +};
>>> +
>>> +static const struct acpi_device_id mma9553_acpi_match[] = {
>>> +	{"MMA9553", 0},
>>> +	{},
>>> +};
>>> +
>>> +MODULE_DEVICE_TABLE(acpi, mma9553_acpi_match);
>>> +
>>> +static const struct i2c_device_id mma9553_id[] = {
>>> +	{"mma9553", 0},
>>> +	{},
>>> +};
>>> +
>>> +MODULE_DEVICE_TABLE(i2c, mma9553_id);
>>> +
>>> +static struct i2c_driver mma9553_driver = {
>>> +	.driver = {
>>> +		   .name = MMA9553_DRV_NAME,
>>> +		   .acpi_match_table = ACPI_PTR(mma9553_acpi_match),
>>> +		   .pm = &mma9553_pm_ops,
>>> +		   },
>>> +	.probe = mma9553_probe,
>>> +	.remove = mma9553_remove,
>>> +	.id_table = mma9553_id,
>>> +};
>>> +
>>> +module_i2c_driver(mma9553_driver);
>>> +
>>> +MODULE_AUTHOR("Irina Tirdea <irina.tirdea@intel.com>");
>>> +MODULE_LICENSE("GPL v2");
>>> +MODULE_DESCRIPTION("MMA9553L pedometer platform driver");
>>>
> 

