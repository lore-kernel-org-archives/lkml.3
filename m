Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbaICO4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:56:37 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52616 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaICO4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:56:33 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-09-54072c1eb453
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [RFC/PATCH 0/6] iio: Add sensorhub driver
Date: Wed, 03 Sep 2014 16:55:44 +0200
Message-id: <1409756150-30889-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJJMWRmVeSWpSXmKPExsVy+t/xa7pyOuwhBm2rJSz+TjrGbrFxxnpW
	iwdNq5gsTi3bz2RxtukNu8W8I+9YLC7vmsPmwO7x+9ckRo9NqzrZPPq2rGL0+LxJLoAlissm
	JTUnsyy1SN8ugSvj8+q7bAXzlCuet3WzNTD+lepi5OSQEDCR2H1+PguELSZx4d56ti5GLg4h
	gaWMEr8+fGaGcPqYJJbdec8GUsUmoC7RvGMxWEJEoJFR4ubifrAEs0AHo8Sidi4QW1jASGLd
	9wXMIDaLgKrE0ePfWEFsXgFnif/XT7J3MXIArVOQmDPJZgIj9wJGhlWMoqmlyQXFSem5RnrF
	ibnFpXnpesn5uZsYIcHxdQfj0mNWhxgFOBiVeHgjBNlChFgTy4orcw8xSnAwK4nwrpFmDxHi
	TUmsrEotyo8vKs1JLT7EyMTBKdXAuGWGd/wHi0XJQT/Va6Pmru48pzlRha92ha+CVOP6+vXS
	ufNNLnx5Zz9nVpaPmRKnRbKK8OrXrZFRDa7uezesXiM0b3qF+eqn0gbFc4UF5h+yORjZLz7n
	kEDmWcEPq1fp+ZQe2OPtv//we0c73q32357UGEg3BrXcN4zra1TTep/6+fOp+G49JZbijERD
	Leai4kQAgB/96+wBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset adds support for sensorhub. It is an external mcu which manages
and collects data from several sensors i.e. on Galaxy Gear 2 watch.

It contains:
- spi driver for sensorhub device
- DT binding for the device
- IIO common utils for ssp sensors, a trigger module
- IIO accelerometer driver
- IIO gyroscope driver

Generally this is an attempt to generalize sensors handling on some Samsung
boards which have multiple sensors IC and also sensorhub does some data
processing itself.

I would like to get your opinion about such solution. The idea is that
data communication layer gives control and data to proper IIO sensor devices.
In this case I chose that sensor drivers are platform ones represented by
child nodes of sensorhub in DT. These compatibles are used mainly to match
sensor to driver. For example at this stage there is one accelerometer but on
other board can have different one with changed data format etc. In this case
ssp_accel_sensor driver could handle several physical devices of accel class.
Unfortunately the firmware gives only an information about used sensor type,
the driver can find out that there is an accelerometer on board but nothing
specific about the sensor.

Other question:
The sensorhub can implement some devices which are non common for IIO and hard
to standardise. These ones need two way communication (raw write will not be
proper for that) and can produce data packets with flexible size to 2KB).
I'm wondering if it is worth to look for solution in IIO and implement
something like IIO_BULK sensor with no standard channel description
or solve this problem using cdev. This is the reason why the part of the 
patchset is intended to be placed in misc.

Regards,
Karol

Karol Wrona (6):
  iio:sensorhub: Add sensorhub common library
  misc: sensorhub: Add sensorhub driver
  sensorhub: Add sensorhub bindings
  iio: sensorhub: Add sensorhub iio commons
  iio: sensorhub: Add sensorhub accelerometer sensor
  iio: sensorhub: Add sensorhub gyroscope sensor

 .../devicetree/bindings/misc/sensorhub.txt         |   51 ++
 drivers/iio/accel/Makefile                         |    2 +
 drivers/iio/accel/ssp_accel_sensor.c               |  240 ++++++
 drivers/iio/common/Kconfig                         |    1 +
 drivers/iio/common/Makefile                        |    1 +
 drivers/iio/common/ssp_sensors/Kconfig             |   15 +
 drivers/iio/common/ssp_sensors/Makefile            |    6 +
 .../iio/common/ssp_sensors/ssp-sensor-trigger.c    |   92 +++
 drivers/iio/common/ssp_sensors/ssp_iio.c           |   35 +
 drivers/iio/common/ssp_sensors/ssp_iio_sensor.h    |   62 ++
 drivers/iio/gyro/Makefile                          |    2 +
 drivers/iio/gyro/ssp_gyro_sensor.c                 |  225 ++++++
 drivers/misc/Kconfig                               |    1 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/sensorhub/Kconfig                     |   13 +
 drivers/misc/sensorhub/Makefile                    |    8 +
 drivers/misc/sensorhub/ssp.h                       |  323 ++++++++
 drivers/misc/sensorhub/ssp_data.c                  |   61 ++
 drivers/misc/sensorhub/ssp_dev.c                   |  782 ++++++++++++++++++++
 drivers/misc/sensorhub/ssp_firmware.c              |  571 ++++++++++++++
 drivers/misc/sensorhub/ssp_spi.c                   |  700 ++++++++++++++++++
 include/linux/iio/common/ssp_sensors.h             |   82 ++
 22 files changed, 3274 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/sensorhub.txt
 create mode 100644 drivers/iio/accel/ssp_accel_sensor.c
 create mode 100644 drivers/iio/common/ssp_sensors/Kconfig
 create mode 100644 drivers/iio/common/ssp_sensors/Makefile
 create mode 100644 drivers/iio/common/ssp_sensors/ssp-sensor-trigger.c
 create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio.c
 create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
 create mode 100644 drivers/iio/gyro/ssp_gyro_sensor.c
 create mode 100644 drivers/misc/sensorhub/Kconfig
 create mode 100644 drivers/misc/sensorhub/Makefile
 create mode 100644 drivers/misc/sensorhub/ssp.h
 create mode 100644 drivers/misc/sensorhub/ssp_data.c
 create mode 100644 drivers/misc/sensorhub/ssp_dev.c
 create mode 100644 drivers/misc/sensorhub/ssp_firmware.c
 create mode 100644 drivers/misc/sensorhub/ssp_spi.c
 create mode 100644 include/linux/iio/common/ssp_sensors.h

-- 
1.7.9.5

