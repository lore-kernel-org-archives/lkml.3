Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab3IAMv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 08:51:56 -0400
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:58705 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab3IAMvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 08:51:54 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AllCAEQ4I1JV5qu1PGdsb2JhbABagweIZ7kLgR4XAwEBAQE4NYIkAQEEAScTHCMFCwgDISUPBSUKGhOHfAq5XBaOK4E+B4MdgQADl3SGQIxhgWg6gS0
X-IronPort-AV: E=Sophos;i="4.89,1001,1367964000"; 
   d="scan'208";a="385650724"
Date: Sun, 1 Sep 2013 14:57:53 +0200
From: Henrik Rydberg <rydberg@euromail.se>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: add driver for Neonode zForce based touchscreens
Message-ID: <20130901125753.GA10455@polaris.bitmath.org>
References: <201308161359.40134.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308161359.40134.heiko@sntech.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

> This adds a driver for touchscreens using the zforce infrared
> technology from Neonode connected via i2c to the host system.
> 
> It supports multitouch with up to two fingers and tracking of the
> contacts in hardware.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Thanks for the driver. Please find some comments below.

> +static int zforce_touch_event(struct zforce_ts *ts, u8 *payload)
> +{
> +	struct i2c_client *client = ts->client;
> +	struct zforce_point point[ZFORCE_REPORT_POINTS];

You do not really need the array here, do you? A single member should
suffice, stack is precious.

> +	const struct zforce_ts_platdata *pdata = client->dev.platform_data;
> +	int count, i;
> +
> +	count = payload[0];
> +	if (count > ZFORCE_REPORT_POINTS) {
> +		dev_warn(&client->dev, "to many coordinates %d, expected max %d\n",
> +			 count, ZFORCE_REPORT_POINTS);
> +		count = ZFORCE_REPORT_POINTS;
> +	}
> +
> +	for (i = 0; i < count; i++) {
> +		point[i].coord_x =
> +			payload[9 * i + 2] << 8 | payload[9 * i + 1];
> +		point[i].coord_y =
> +			payload[9 * i + 4] << 8 | payload[9 * i + 3];
> +
> +		if (point[i].coord_x > pdata->x_max ||
> +		    point[i].coord_y > pdata->y_max) {
> +			dev_warn(&client->dev, "coordinates (%d,%d) invalid\n",
> +				point[i].coord_x, point[i].coord_y);
> +			point[i].coord_x = point[i].coord_y = 0;
> +		}
> +
> +		point[i].state = payload[9 * i + 5] & 0x03;
> +		point[i].id = (payload[9 * i + 5] & 0xfc) >> 2;
> +
> +		/* determine touch major, minor and orientation */
> +		point[i].area_major = max(payload[9 * i + 6],
> +					  payload[9 * i + 7]);
> +		point[i].area_minor = min(payload[9 * i + 6],
> +					  payload[9 * i + 7]);
> +		point[i].orientation = payload[9 * i + 6] > payload[9 * i + 7];
> +
> +		point[i].pressure = payload[9 * i + 8];
> +		point[i].prblty = payload[9 * i + 9];
> +	}
> +
> +	for (i = 0; i < count; i++) {

just continue the loop here (or move the conversion out as a function).

> +		dev_dbg(&client->dev, "point %d/%d: state %d, id %d, pressure %d, prblty %d, x %d, y %d, amajor %d, aminor %d, ori %d\n",
> +			i, count, point[i].state, point[i].id,
> +			point[i].pressure, point[i].prblty,
> +			point[i].coord_x, point[i].coord_y,
> +			point[i].area_major, point[i].area_minor,
> +			point[i].orientation);
> +
> +		/* the zforce id starts with "1", so needs to be decreased */
> +		input_mt_slot(ts->input, point[i].id - 1);
> +
> +		input_mt_report_slot_state(ts->input, MT_TOOL_FINGER,
> +						point[i].state != STATE_UP);
> +
> +		if (point[i].state != STATE_UP) {
> +			input_report_abs(ts->input, ABS_MT_POSITION_X,
> +					 point[i].coord_x);
> +			input_report_abs(ts->input, ABS_MT_POSITION_Y,
> +					 point[i].coord_y);
> +			input_report_abs(ts->input, ABS_MT_TOUCH_MAJOR,
> +					 point[i].area_major);
> +			input_report_abs(ts->input, ABS_MT_TOUCH_MINOR,
> +					 point[i].area_minor);
> +			input_report_abs(ts->input, ABS_MT_ORIENTATION,
> +					 point[i].orientation);
> +		}
> +	}
> +
> +	if (point[0].state != STATE_UP) {
> +		input_report_abs(ts->input, ABS_X, point[0].coord_x);
> +		input_report_abs(ts->input, ABS_Y, point[0].coord_y);
> +	}
> +
> +	input_report_key(ts->input, BTN_TOUCH, point[0].state != STATE_UP);

You can use input_mt_sync() here instead of the single-touch stuff.

> +
> +	input_sync(ts->input);
> +
> +	return 0;
> +}
> +
> +static int zforce_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	const struct zforce_ts_platdata *pdata = client->dev.platform_data;
> +	struct zforce_ts *ts;
> +	struct input_dev *input_dev;
> +	int ret;
> +
> +	if (!pdata)
> +		return -EINVAL;
> +
> +	ts = devm_kzalloc(&client->dev, sizeof(struct zforce_ts), GFP_KERNEL);
> +	if (!ts)
> +		return -ENOMEM;
> +
> +	ret = devm_gpio_request_one(&client->dev, pdata->gpio_int, GPIOF_IN,
> +				    "zforce_ts_int");
> +	if (ret) {
> +		dev_err(&client->dev, "request of gpio %d failed, %d\n",
> +			pdata->gpio_int, ret);
> +		return ret;
> +	}
> +
> +	ret = devm_gpio_request_one(&client->dev, pdata->gpio_rst,
> +				    GPIOF_OUT_INIT_LOW, "zforce_ts_rst");
> +	if (ret) {
> +		dev_err(&client->dev, "request of gpio %d failed, %d\n",
> +			pdata->gpio_rst, ret);
> +		return ret;
> +	}
> +
> +	ret = devm_add_action(&client->dev, zforce_reset, ts);
> +	if (ret) {
> +		dev_err(&client->dev, "failed to register reset action, %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	msleep(20);
> +
> +	snprintf(ts->phys, sizeof(ts->phys),
> +		 "%s/input0", dev_name(&client->dev));
> +
> +	input_dev = devm_input_allocate_device(&client->dev);
> +	if (!input_dev) {
> +		dev_err(&client->dev, "could not allocate input device\n");
> +		return -ENOMEM;
> +	}
> +
> +	mutex_init(&ts->access_mutex);
> +	mutex_init(&ts->command_mutex);
> +
> +	ts->pdata = pdata;
> +	ts->client = client;
> +	ts->input = input_dev;
> +
> +	input_dev->name = "Neonode zForce touchscreen";
> +	input_dev->phys = ts->phys;
> +	input_dev->id.bustype = BUS_I2C;
> +	input_dev->dev.parent = &client->dev;
> +
> +	input_dev->open = zforce_input_open;
> +	input_dev->close = zforce_input_close;
> +
> +	set_bit(EV_KEY, input_dev->evbit);
> +	set_bit(EV_SYN, input_dev->evbit);
> +	set_bit(EV_ABS, input_dev->evbit);
> +	set_bit(BTN_TOUCH, input_dev->keybit);

BTN_TOUCH can be skipped,

> +
> +	/* For single touch */
> +	input_set_abs_params(input_dev, ABS_X, 0, pdata->x_max, 0, 0);
> +	input_set_abs_params(input_dev, ABS_Y, 0, pdata->y_max, 0, 0);

and these too,

> +
> +	/* For multi touch */
> +	input_mt_init_slots(input_dev, ZFORCE_REPORT_POINTS, 0);

if you add INPUT_MT_DIRECT as argument here.

> +	input_set_abs_params(input_dev, ABS_MT_POSITION_X, 0,
> +			     pdata->x_max, 0, 0);
> +	input_set_abs_params(input_dev, ABS_MT_POSITION_Y, 0,
> +			     pdata->y_max, 0, 0);
> +
> +	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR, 0,
> +			     ZFORCE_MAX_AREA, 0, 0);
> +	input_set_abs_params(input_dev, ABS_MT_TOUCH_MINOR, 0,
> +			     ZFORCE_MAX_AREA, 0, 0);
> +	input_set_abs_params(input_dev, ABS_MT_ORIENTATION, 0, 1, 0, 0);
> +
> +	input_set_drvdata(ts->input, ts);
> +
> +	init_completion(&ts->command_done);
> +
> +	/* The zforce pulls the interrupt low when it has data ready.
> +	 * After it is triggered the isr thread runs until all the available
> +	 * packets have been read and the interrupt is high again.
> +	 * Therefore we can trigger the interrupt anytime it is low and do
> +	 * not need to limit it to the interrupt edge.
> +	 */
> +	ret = devm_request_threaded_irq(&client->dev, client->irq, NULL,
> +					zforce_interrupt,
> +					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +					input_dev->name, ts);
> +	if (ret) {
> +		dev_err(&client->dev, "irq %d request failed\n", client->irq);
> +		return ret;
> +	}
> +
> +	i2c_set_clientdata(client, ts);
> +
> +	/* let the controller boot */
> +	gpio_set_value(pdata->gpio_rst, 1);
> +
> +	ts->command_waiting = NOTIFICATION_BOOTCOMPLETE;
> +	if (wait_for_completion_timeout(&ts->command_done, WAIT_TIMEOUT) == 0)
> +		dev_warn(&client->dev, "bootcomplete timed out\n");
> +
> +	/* need to start device to get version information */
> +	ret = zforce_command_wait(ts, COMMAND_INITIALIZE);
> +	if (ret) {
> +		dev_err(&client->dev, "unable to initialize, %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* this gets the firmware version among other informations */
> +	ret = zforce_command_wait(ts, COMMAND_STATUS);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "couldn't get status, %d\n", ret);
> +		zforce_stop(ts);
> +		return ret;
> +	}
> +
> +	/* stop device and put it into sleep until it is opened */
> +	ret = zforce_stop(ts);
> +	if (ret < 0)
> +		return ret;
> +
> +	device_set_wakeup_capable(&client->dev, true);
> +
> +	ret = input_register_device(input_dev);
> +	if (ret) {
> +		dev_err(&client->dev, "could not register input device, %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}

Thanks,
Henrik
